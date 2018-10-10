program test_get_component_name

  use bmif, only: BMI_FAILURE, BMI_MAX_COMPONENT_NAME
  use bmiheatf
  use fixtures, only: status

  implicit none

  character (len=BMI_MAX_COMPONENT_NAME), parameter :: &
       expected = "The 2D Heat Equation"
  type (bmi_heat) :: m
  character (len=BMI_MAX_COMPONENT_NAME), pointer :: name

  status = m%get_component_name(name)

  if (name.ne.expected) then
     stop BMI_FAILURE
  end if
end program test_get_component_name
