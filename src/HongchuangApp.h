/****************************************************************/
/*               MOOSE Multiphysics Simulation                  */
/*     Hongchuang Technology Multi-Physics Engine               */
/*                                                              */
/*            Core Application Header — HongchuangApp            */
/****************************************************************/

#pragma once

#include "MooseApp.h"

/**
 * HongchuangApp — The core simulation application for the
 * Hongchuang Multi-Physics Engine.
 *
 * This class serves as the entry point for all simulation
 * workflows. It registers kernels, materials, boundary
 * conditions, and solver infrastructure specific to
 * Hongchuang Technology's multi-physics platform.
 */
class HongchuangApp : public MooseApp
{
public:
  static InputParameters validParams();

  HongchuangApp(InputParameters parameters);
  virtual ~HongchuangApp();

  /** Register all objects, syntax, and actions */
  static void registerAll(Factory & f, ActionFactory & af, Syntax & s);

  /** Register the application itself */
  static void registerApps();

  /** Print the branded header/logo */
  virtual void header() const override;

protected:
  /** Register kernel objects */
  static void registerObjects(Factory & factory);

  /** Register auxiliary kernel objects */
  static void registerAuxKernels(Factory & factory, Syntax & syntax);

  /** Register custom syntax */
  static void registerSyntax(Syntax & syntax);
};
