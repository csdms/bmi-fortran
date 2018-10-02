program test_get_component_name

  use bmiheatf
  use fixtures, only: status

  implicit none

  type (bmi_heat) :: m
  character (len=BMI_MAXCOMPNAMESTR), pointer :: name

  status = m%get_component_name(name)

  if (name.ne.component_name) then
     stop 1
  end if
end program test_get_component_name
