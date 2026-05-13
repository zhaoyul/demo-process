/****************************************************************/
/*               MOOSE Multiphysics Simulation                  */
/*     Hongchuang Technology Multi-Physics Engine               */
/*                                                              */
/*  Material: ConcreteDamagePlasticityStressUpdate (CDP)         */
/*  混凝土塑性损伤本构实现                                      */
/****************************************************************/

#include "ConcreteDamagePlasticityStressUpdate.h"
#include "RankTwoTensor.h"
#include "RankFourTensor.h"
#include "Conversion.h"

#include <cmath>
#include <algorithm>

registerMooseObject("HongchuangApp", ConcreteDamagePlasticityStressUpdate);

InputParameters
ConcreteDamagePlasticityStressUpdate::validParams()
{
  InputParameters params = ADComputeStressBase::validParams();

  params.addClassDescription(
    "C30 混凝土塑性损伤本构模型 (Concrete Damaged Plasticity, CDP)。\n"
    "实现基于主应力的标量损伤演化:\n"
    "  受拉: d_t = 1 - (f_t / σ₁) · exp(α_t · (f_t - σ₁)), 当 σ₁ > f_t\n"
    "  受压: d_c = 1 - (f_c / |σ₃|) · exp(α_c · (f_c - |σ₃|)), 当 |σ₃| > f_c\n"
    "  有效应力: σ_eff = (1 - d_total) · C₀ : ε^el, 其中 d_total = max(d_t, d_c)\n\n"
    "C30 混凝土参数 (参照 GB 50010-2010):\n"
    "  E = 30 GPa, ν = 0.20, f_t = 2.0 MPa, f_c = 20.0 MPa\n"
    "  α_t = 5.0×10⁻⁷ /Pa, α_c = 2.0×10⁻⁷ /Pa");

  // ── C30 混凝土弹性参数 ──
  params.addRequiredParam<Real>("youngs_modulus",
    "Young's modulus [Pa] (C30: 30.0e9)");
  params.addRequiredParam<Real>("poissons_ratio",
    "Poisson's ratio [-] (C30: 0.20)");

  // ── 强度参数 ──
  params.addRequiredParam<Real>("f_t",
    "Tensile strength [Pa] (C30: 2.0e6)");
  params.addRequiredParam<Real>("f_c",
    "Compressive strength [Pa] (C30: 20.0e6)");

  // ── 损伤演化参数 ──
  params.addRequiredParam<Real>("alpha_t",
    "Tensile softening parameter [1/Pa] (C30: 5.0e-7)");
  params.addRequiredParam<Real>("alpha_c",
    "Compressive softening parameter [1/Pa] (C30: 2.0e-7)");

  return params;
}

ConcreteDamagePlasticityStressUpdate::ConcreteDamagePlasticityStressUpdate(
    const InputParameters & parameters)
  : ADComputeStressBase(parameters),
    // ── Declare damage material properties for output ──
    _damage_t(declareADProperty<Real>("damage_t")),
    _damage_c(declareADProperty<Real>("damage_c")),
    _damage_total(declareADProperty<Real>("damage_total")),
    _undamaged_stiffness(declareADProperty<RankFourTensor>("undamaged_stiffness")),
    // ── Read C30 concrete parameters ──
    _youngs_modulus(getParam<Real>("youngs_modulus")),
    _poissons_ratio(getParam<Real>("poissons_ratio")),
    _f_t(getParam<Real>("f_t")),
    _f_c(getParam<Real>("f_c")),
    _alpha_t(getParam<Real>("alpha_t")),
    _alpha_c(getParam<Real>("alpha_c")),
    _stiffness_initialized(false)
{
}

void
ConcreteDamagePlasticityStressUpdate::initQpStatefulProperties()
{
  // Initialize damage state to zero (undamaged)
  _damage_t[_qp] = 0.0;
  _damage_c[_qp] = 0.0;
  _damage_total[_qp] = 0.0;
}

void
ConcreteDamagePlasticityStressUpdate::computeQpStress()
{
  // ── Step 1: Compute undamaged isotropic stiffness tensor ──
  if (!_stiffness_initialized)
  {
    const Real E = _youngs_modulus;
    const Real nu = _poissons_ratio;

    // Lame constants
    const Real lambda = E * nu / ((1.0 + nu) * (1.0 - 2.0 * nu));
    const Real mu = E / (2.0 * (1.0 + nu));

    // Build isotropic elasticity tensor C_ijkl = λ·δ_ij·δ_kl + μ·(δ_ik·δ_jl + δ_il·δ_jk)
    _C0 = RankFourTensor();
    _C0.fillGeneralIsotropic(lambda, mu);

    _stiffness_initialized = true;
  }

  _undamaged_stiffness[_qp] = _C0;

  // ── Step 2: Compute elastic trial stress (undamaged) ──
  // σ_trial = C₀ : ε^el
  ADRankTwoTensor stress_trial = _C0 * _elastic_strain[_qp];

  // Extract non-AD stress for principal stress computation
  // (eigenvalue decomposition is not AD-differentiable)
  RankTwoTensor stress_trial_raw;
  for (unsigned int i = 0; i < 3; ++i)
    for (unsigned int j = 0; j < 3; ++j)
      stress_trial_raw(i, j) = MetaPhysicL::raw_value(stress_trial(i, j));

  // ── Step 3: Compute principal stresses ──
  std::vector<Real> principal = {0.0, 0.0, 0.0};
  stress_trial_raw.symmetricEigenvalues(principal);

  // Sort: max (σ₁), mid (σ₂), min (σ₃)
  std::sort(principal.begin(), principal.end(), std::greater<Real>());

  const Real s1 = principal[0];  // max principal (tension)
  const Real s3 = principal[2];  // min principal (compression)

  // ── Step 4: Compute tensile damage (d_t) ──
  Real d_t_local = 0.0;
  if (s1 > _f_t)
  {
    // d_t = 1 - (f_t / σ₁) · exp(α_t · (f_t - σ₁))
    // Clamp the exponential argument to prevent overflow
    Real exp_arg = _alpha_t * (_f_t - s1);
    exp_arg = std::max(exp_arg, -700.0);  // exp(-700) ≈ 9.86e-305, near double min
    exp_arg = std::min(exp_arg, 700.0);   // exp(700) is safe on double
    Real d_t_raw = 1.0 - (_f_t / s1) * std::exp(exp_arg);
    d_t_local = std::max(0.0, std::min(d_t_raw, 1.0));
  }

  // ── Step 5: Compute compressive damage (d_c) ──
  Real d_c_local = 0.0;
  const Real abs_s3 = std::abs(s3);
  if (abs_s3 > _f_c)
  {
    // d_c = 1 - (f_c / |σ₃|) · exp(α_c · (f_c - |σ₃|))
    Real exp_arg = _alpha_c * (_f_c - abs_s3);
    exp_arg = std::max(exp_arg, -700.0);
    exp_arg = std::min(exp_arg, 700.0);
    Real d_c_raw = 1.0 - (_f_c / abs_s3) * std::exp(exp_arg);
    d_c_local = std::max(0.0, std::min(d_c_raw, 1.0));
  }

  // ── Step 6: Total damage ──
  const Real d_total_local = std::max(d_t_local, d_c_local);

  // ── Step 7: Compute damaged stiffness ──
  // Effective stiffness: C_eff = (1 - d_total) · C₀
  // Effective stress:  σ_eff   = (1 - d_total) · C₀ : ε^el
  const Real degradation = 1.0 - std::max(0.0, std::min(d_total_local, 0.999999));
  ADRankTwoTensor stress_eff = stress_trial * degradation;

  // ── Step 8: Assign computed stress and damage ──
  _stress[_qp] = stress_eff;

  // Store damage as ADReal for consistency with the material property system
  _damage_t[_qp] = d_t_local;
  _damage_c[_qp] = d_c_local;
  _damage_total[_qp] = d_total_local;
}
