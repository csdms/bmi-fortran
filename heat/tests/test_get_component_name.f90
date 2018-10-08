program test_get_component_name

  use bmif, only: BMI_FAILURE, BMI_MAX_COMPONENT_NAME
  use bmiheatf
  use fixtures, only: status

  implicit none

  type (bmi_heat) :: m
  character (len=BMI_MAX_COMPONENT_NAME), pointer :: name

  status = m%get_component_name(name)

  if (name.ne.component_name) then
     stop BMI_FAILURE
  end if
end program test_get_component_name
