#ifndef MACROELASTIC_H
#define MACROELASTIC_H

#include "Elastic.h"

class MacroElastic : public Elastic
{
public:
  MacroElastic( const std::string & name,
                InputParameters parameters );
  virtual ~MacroElastic();

protected:

  virtual void initQpStatefulProperties() {}



  /// Compute the stress (sigma += deltaSigma)
  virtual bool updateElasticityTensor(SymmElasticityTensor & tensor);

  virtual void checkElasticConstants() {}

private:
  const PostprocessorValue & _C1111;
  const PostprocessorValue & _C1122;
  const PostprocessorValue & _C1133;
  const PostprocessorValue & _C2222;
  const PostprocessorValue & _C2233;
  const PostprocessorValue & _C3333;
  const PostprocessorValue & _C1212;
  const PostprocessorValue & _C2323;
  const PostprocessorValue & _C3131;

};

template<>
InputParameters validParams<Elastic>();


#endif
