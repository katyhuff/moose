[GlobalParams]
  order = FIRST
  family = LAGRANGE
  displacements = 'disp_x disp_y'
  scalar_strain_zz = scalar_strain_zz
  temp = temp
[]

[Mesh]
  file = 2squares.e
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./temp]
  [../]
  [./scalar_strain_zz]
    order = FIRST
    family = SCALAR
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./aux_strain_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Postprocessors]
  [./react_z]
    type = MaterialTensorIntegral
    rank_two_tensor = stress
    index_i = 2
    index_j = 2
  [../]
[]

[UserObjects]
  [./gpsuo]
    type = GeneralizedPlaneStrainUserObject
  [../]
[]

[Kernels]
  [./TensorMechanics]
    use_displaced_mesh = true
  [../]
  [./gps_x]
    type = GeneralizedPlaneStrainOffDiag
    variable = disp_x
  [../]
  [./gps_y]
    type = GeneralizedPlaneStrainOffDiag
    variable = disp_y
  [../]
  [./heat]
    type = HeatConduction
    variable = temp
  [../]
[]

[ScalarKernels]
  [./gps]
    type = GeneralizedPlaneStrain
    variable = scalar_strain_zz
    generalized_plane_strain = gpsuo
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]

  [./strain_xx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xx
    index_i = 0
    index_j = 0
  [../]
  [./strain_xy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xy
    index_i = 0
    index_j = 1
  [../]
  [./strain_yy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_yy
    index_i = 1
    index_j = 1
  [../]
  [./strain_zz]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = aux_strain_zz
    index_i = 2
    index_j = 2
  [../]
[]

[Functions]
  [./tempramp]
    type = ParsedFunction
    value = 't'
  [../]
[]

[BCs]
  [./x]
    type = DirichletBC
    boundary = '4 6'
    variable = disp_x
    value = 0.0
  [../]
  [./y]
    type = DirichletBC
    boundary = '1 5' #'4 6'
    variable = disp_y
    value = 0.0
  [../]
  [./t]
    type = DirichletBC
    boundary = '4'
    variable = temp
    value = 0.0
  [../]
  [./tramp]
    type = FunctionPresetBC
    variable = temp
    boundary = '6'
    function = tempramp
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
#    full = true
    off_diag_row =    'disp_x disp_y'
    off_diag_column = 'disp_y disp_x'
  [../]
[]

[Contact]
  [./mech]
    master = 8
    slave = 2
    disp_x = disp_x
    disp_y = disp_y
    penalty = 1e+10
    normalize_penalty = true
    system = Constraint
    tangential_tolerance = .1
    normal_smoothing_distance = .1
    model = frictionless
    formulation = kinematic
  [../]
[]

[ThermalContact]
  [./thermal]
    type = GapHeatTransfer
    master = 8
    slave = 2
    variable = temp
    tangential_tolerance = .1
    normal_smoothing_distance = .1
    gap_conductivity = 0.01
    min_gap = 0.001
#    quadrature = true
  [../]
[]

[Materials]
  [./elastic_tensor]
    type = ComputeIsotropicElasticityTensor
    poissons_ratio = 0.3
    youngs_modulus = 1e6
    block = '1 2'
  [../]
  [./strain]
    type = ComputePlaneSmallStrain
    block = '1 2'
  [../]
  [./thermal_strain]
    type = ComputeThermalExpansionEigenStrain
    temperature = temp
    thermal_expansion_coeff = 0.02
    stress_free_reference_temperature = 0.0
    block = '1 2'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
    block = '1 2'
  [../]

  [./heatcond]
    type = HeatConductionMaterial
    thermal_conductivity = 3.0
    specific_heat = 300.0
    block = '1 2'
  [../]
[]

[Executioner]
  type = Transient

  solve_type = PJFNK
  line_search = none

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'

# controls for linear iterations
  l_max_its = 100
  l_tol = 1e-4

# controls for nonlinear iterations
  nl_max_its = 20
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-4

# time control
  start_time = 0.0
  dt = 0.2
  dtmin = 0.2
  end_time = 2.0
  num_steps = 5000
[]

[Outputs]
  exodus = true
[]
