! Test the basic info BMI methods.
program info_test

  use bmiheatf
  implicit none

  type (bmi_heat) :: m
  integer :: s
  character (len=BMI_MAXCOMPNAMESTR), pointer :: name
  character (len=BMI_MAXVARNAMESTR), pointer :: names(:)

  write (*,"(a)") "Component info"

  s = m%get_component_name(name)
  write (*,"(a30, a30)") "Component name: ", name

  s = m%get_input_var_names(names)
  write (*,"(a30, a30)") "Input variables: ", names
  s = m%get_output_var_names(names)
  write (*,"(a30, a30)") "Output variables: ", names

end program info_test
