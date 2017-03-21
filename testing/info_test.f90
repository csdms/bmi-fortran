! Test the basic info and time BMI methods.
program info_test

  use bmiheatf
  implicit none

  type (bmi_heat) :: m
  integer :: s
  character (len=BMI_MAXCOMPNAMESTR), pointer :: name

  write (*,"(a)") "Component info"

  s = m%get_component_name(name)
  write (*,"(a30, a30)") "Component name: ", name

end program info_test
