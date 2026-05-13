/****************************************************************/
/*               MOOSE Multiphysics Simulation                  */
/*     Hongchuang Technology Multi-Physics Engine               */
/*                                                              */
/*  Material: ConcreteDamagePlasticityStressUpdate (CDP)         */
/*  混凝土塑性损伤本构模型 (Concrete Damaged Plasticity)         */
/****************************************************************/

#pragma once

#include "ADComputeStressBase.h"

/**
 * ConcreteDamagePlasticityStressUpdate — C30 混凝土塑性损伤本构模型
 *
 * 实现基于主应力的标量损伤演化，用于混凝土结构的非线性分析。
 *
 * 本构关系:
 *   σ_eff = (1 - d_total) · C : ε^el
 *
 * 损伤演化:
 *   受拉损伤 (σ₁ > f_t):
 *     d_t = 1 - (f_t / σ₁) · exp(α_t · (f_t - σ₁))
 *   受压损伤 (|σ₃| > f_c):
 *     d_c = 1 - (f_c / |σ₃|) · exp(α_c · (f_c - |σ₃|))
 *   总损伤:
 *     d_total = max(d_t, d_c)
 *
 * C30 混凝土参数 (参照 GB 50010-2010):
 *   E  = 30 GPa        (弹性模量)
 *   ν  = 0.20          (泊松比)
 *   f_t = 2.0 MPa      (抗拉强度标准值)
 *   f_c = 20.0 MPa     (抗压强度标准值)
 *   α_t = 5.0 × 10⁻⁷ / Pa  (受拉软化参数)
 *   α_c = 2.0 × 10⁻⁷ / Pa  (受压软化参数)
 */
class ConcreteDamagePlasticityStressUpdate : public ADComputeStressBase
{
public:
  static InputParameters validParams();

  ConcreteDamagePlasticityStressUpdate(const InputParameters & parameters);

protected:
  /// Compute the damaged stress at each quadrature point
  virtual void computeQpStress() override;

  /// Initialize the damage state properties
  virtual void initQpStatefulProperties() override;

  // ── Material properties (declared for output) ──
  /// Tensile damage variable (0-1)
  ADMaterialProperty<Real> & _damage_t;

  /// Compressive damage variable (0-1)
  ADMaterialProperty<Real> & _damage_c;

  /// Total damage variable d = max(d_t, d_c)
  ADMaterialProperty<Real> & _damage_total;

  /// Original (undamaged) stiffness tensor for output / diagnostics
  ADMaterialProperty<RankFourTensor> & _undamaged_stiffness;

  // ── C30 Concrete material parameters ──
  /// Young's modulus [Pa]
  const Real _youngs_modulus;

  /// Poisson's ratio [-]
  const Real _poissons_ratio;

  /// Tensile strength [Pa]
  const Real _f_t;

  /// Compressive strength [Pa]
  const Real _f_c;

  /// Tensile softening parameter [1/Pa]
  const Real _alpha_t;

  /// Compressive softening parameter [1/Pa]
  const Real _alpha_c;

  // ── Cached stiffness tensor ──
  /// Isotropic elasticity tensor (undamaged)
  RankFourTensor _C0;

  /// Whether the stiffness has been initialized
  bool _stiffness_initialized;
};
