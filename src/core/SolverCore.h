/****************************************************************/
/*               MOOSE Multiphysics Simulation                  */
/*     Hongchuang Technology Multi-Physics Engine               */
/*                                                              */
/*              Core Solver Module — SolverCore                  */
/****************************************************************/

#pragma once

#include "Kernel.h"

/**
 * SolverCore — The fundamental computational kernel for
 * Hongchuang's multi-physics simulation engine.
 *
 * This kernel implements the generic residual and Jacobian
 * formulation that serves as the backbone for:
 *   - Heat conduction
 *   - Solid mechanics (elasticity / plasticity)
 *   - Fluid dynamics
 *   - Coupled multi-physics problems
 *
 * It is designed to be extended by domain-specific solver
 * modules that override the residual formulation.
 */
class SolverCore : public Kernel
{
public:
  static InputParameters validParams();

  SolverCore(const InputParameters & parameters);

protected:
  /** Compute the residual for the governing equation */
  virtual Real computeQpResidual() override;

  /** Compute the on-diagonal Jacobian */
  virtual Real computeQpJacobian() override;

  /** Laplacian coefficient (diffusivity / stiffness) */
  const Real & _coefficient;

  /** Optional: time derivative coefficient */
  const Real & _time_coefficient;
};
