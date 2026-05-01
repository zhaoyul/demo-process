/****************************************************************/
/*               MOOSE Multiphysics Simulation                  */
/*     Hongchuang Technology Multi-Physics Engine               */
/*                                                              */
/*              Core Solver Module — SolverCore                  */
/****************************************************************/

#include "SolverCore.h"
#include "Assembly.h"

registerMooseObject("HongchuangApp", SolverCore);

InputParameters
SolverCore::validParams()
{
  InputParameters params = Kernel::validParams();

  params.addRequiredParam<Real>("coefficient",
    "Diffusivity / stiffness coefficient for the governing PDE");

  params.addParam<Real>("time_coefficient", 1.0,
    "Time derivative coefficient (default: 1.0)");

  params.addClassDescription(
    "Core solver kernel for Hongchuang Multi-Physics Engine. "
    "Implements the generic residual: ∇·(c∇u) + τ ∂u/∂t");

  return params;
}

SolverCore::SolverCore(const InputParameters & parameters)
  : Kernel(parameters),
    _coefficient(getParam<Real>("coefficient")),
    _time_coefficient(getParam<Real>("time_coefficient"))
{
}

Real
SolverCore::computeQpResidual()
{
  // Standard Galerkin weak form:
  //   R_i = ∫_Ω [ c · ∇φ_i · ∇u + τ · φ_i · ∂u/∂t ] dΩ
  //
  // At quadrature point level:
  //   R_QP = c · (∇φ · ∇u) + τ · φ · u_dot

  Real residual = _coefficient * _grad_test[_i][_qp] * _grad_u[_qp];

  // Time derivative term (transient problems)
  if (_time_coefficient != 0.0)
    residual += _time_coefficient * _test[_i][_qp] * _u_dot[_qp];

  return residual;
}

Real
SolverCore::computeQpJacobian()
{
  // On-diagonal Jacobian:
  //   J_ii = c · ∇φ_i · ∇φ_j + τ · φ_i · φ_j · du_dot/du
  //
  // Using standard MOOSE du_dot_du for time derivative scaling.

  Real jacobian = _coefficient * _grad_test[_i][_qp] * _grad_phi[_j][_qp];

  // Time derivative Jacobian component
  if (_time_coefficient != 0.0)
    jacobian += _time_coefficient * _test[_i][_qp] * _phi[_j][_qp] * _du_dot_du[_qp];

  return jacobian;
}
