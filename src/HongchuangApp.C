/****************************************************************/
/*               MOOSE Multiphysics Simulation                  */
/*     Hongchuang Technology Multi-Physics Engine               */
/*                                                              */
/*            Core Application — HongchuangApp                   */
/****************************************************************/

#include "HongchuangApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

// Core solver modules
#include "core/SolverCore.h"

registerKnownLabel("HongchuangApp");

InputParameters
HongchuangApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

HongchuangApp::HongchuangApp(InputParameters parameters)
  : MooseApp(parameters)
{
  HongchuangApp::registerAll(_factory, _action_factory, _syntax);
}

HongchuangApp::~HongchuangApp() {}

void
HongchuangApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);

  // Register core solver objects
  registerObjects(f);
  registerSyntax(s);
  registerAuxKernels(f, s);
}

void
HongchuangApp::registerApps()
{
  registerApp(HongchuangApp);
}

void
HongchuangApp::registerObjects(Factory & factory)
{
  // Core solver
  registerKernel(SolverCore);
}

void
HongchuangApp::registerAuxKernels(Factory & factory, Syntax & syntax)
{
  // Future: register auxiliary kernels here
}

void
HongchuangApp::registerSyntax(Syntax & syntax)
{
  // Future: register custom syntax actions here
}

/****************************************************************/
/*                       HEADER — Branded ASCII Art              */
/****************************************************************/

void
HongchuangApp::header() const
{
  mooseConsole()
    << "\n"
    << "  ╔══════════════════════════════════════════════════════╗\n"
    << "  ║                                                      ║\n"
    << "  ║     _   _                       _                    ║\n"
    << "  ║    | | | | ___  _ __   __ _ ___| |__  _   _  __ _   ║\n"
    << "  ║    | |_| |/ _ \\| '_ \\ / _` / __| '_ \\| | | |/ _` |  ║\n"
    << "  ║    |  _  | (_) | | | | (_| \\__ \\ | | | |_| | (_| |  ║\n"
    << "  ║    |_| |_|\\___/|_| |_|\\__, |___/_| |_|\\__,_|\\__,_|  ║\n"
    << "  ║                        |___/                          ║\n"
    << "  ║                                                      ║\n"
    << "  ║      红创科技 多物理场仿真引擎 v1.0                    ║\n"
    << "  ║      Hongchuang Multi-Physics Engine                   ║\n"
    << "  ║                                                      ║\n"
    << "  ║      Core Module | 核心求解器模块                       ║\n"
    << "  ║      (c) 2024 Hongchuang Technology Co., Ltd.         ║\n"
    << "  ║                                                      ║\n"
    << "  ╚══════════════════════════════════════════════════════╝\n"
    << "\n"
    << "  [*] Initializing computational framework...\n"
    << "  [*] Loading physics modules...\n"
    << "  [*] Preparing parallel execution environment...\n"
    << "\n";
}
