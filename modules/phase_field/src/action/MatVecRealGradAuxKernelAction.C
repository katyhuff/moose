/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "MatVecRealGradAuxKernelAction.h"
#include "Factory.h"
#include "Parser.h"
#include "Conversion.h"
#include "FEProblem.h"

template<>
InputParameters validParams<MatVecRealGradAuxKernelAction>()
{
  InputParameters params = validParams<Action>();
  params.addRequiredParam<unsigned int>("op_num", "Value that specifies the number of grains to create");
  params.addRequiredParam<std::vector<std::string> >("var_name_base", "Vector specifies the base name of the variables");
  params.addRequiredParam<std::vector<MaterialPropertyName> >("property", "the scalar material property names");
  params.addParam<bool>("use_displaced_mesh", false, "Whether to use displaced mesh in the kernels");
  params.addRequiredParam<unsigned int>("dim", "the dimensions of the mesh");
  params.addParam<AuxVariableName>("divergence_variable", "Name of divergence variable to generate kernels for");
  params.addParam<MaterialPropertyName>("divergence_property", "Scalar material property name for divergence variable");
  return params;
}

MatVecRealGradAuxKernelAction::MatVecRealGradAuxKernelAction(const InputParameters & params) :
    Action(params)
{
  mooseDeprecated("Use 'MaterialVectorAuxKernel' or 'MaterialVectorGradAuxKernel' action instead depending on data_type of MaterialProperty<std::vector<date_type> >");
}

void
MatVecRealGradAuxKernelAction::act()
{
  std::vector<std::string> var_name_base = getParam<std::vector<std::string> >("var_name_base");
  std::vector<MaterialPropertyName> _prop = getParam<std::vector<MaterialPropertyName> >("property");
  AuxVariableName _div_var = getParam<AuxVariableName>("divergence_variable");
  MaterialPropertyName _div_prop = getParam<MaterialPropertyName>("divergence_property");

  unsigned int op_num = getParam<unsigned int>("op_num");
  unsigned int dim = getParam<unsigned int>("dim");
  unsigned int size_v = var_name_base.size();
  unsigned int size_p = _prop.size();

  if (size_p != size_v)
    mooseError("var_name_base and property must be vectors of the same dimension");

  for (unsigned int op = 0; op < op_num; ++op)
  {
    for (unsigned int val = 0; val < size_v; ++val)
      for (unsigned int x = 0; x < dim; ++x)
      {


        std::string var_name = var_name_base[val] + Moose::stringify(x) + Moose::stringify(op);
        {
          InputParameters params = _factory.getValidParams("MaterialStdVectorRealGradientAux");
          params.set<AuxVariableName>("variable") = var_name;
          params.set<MaterialPropertyName>("property") = _prop[val];
          params.set<unsigned int>("component") = x;
          params.set<unsigned int>("index") = op;
          params.set<bool>("use_displaced_mesh") = getParam<bool>("use_displaced_mesh");

          std::string aux_kernel_name = "grad_" + var_name;
          _problem->addAuxKernel("MaterialStdVectorRealGradientAux", aux_kernel_name, params);
        }
      }

    if (isParamValid("divergence_variable"))
    {
      if (isParamValid("divergence_property"))
      {
        InputParameters params = _factory.getValidParams("MaterialStdVectorAux");
        params.set<AuxVariableName>("variable") = _div_var;
        params.set<MaterialPropertyName>("property") = _div_prop;
        params.set<unsigned int>("index") = op;
        params.set<bool>("use_displaced_mesh") = getParam<bool>("use_displaced_mesh");

        std::string aux_kernel_name = "div_" + Moose::stringify(op);
        _problem->addAuxKernel("MaterialStdVectorAux", aux_kernel_name, params);
      }
      else
        mooseError("Must specify a divergence_property name along with divergence_variable name");
    }
  }
}
