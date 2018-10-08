program test_update

  use bmif, only: BMI_FAILURE
  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: expected_time = 1.0

  type (bmi_heat) :: m
  real :: time

  status = m%initialize(config_file)
  status = m%update()
  status = m%get_current_time(time)
  status = m%finalize()

  if (time.ne.expected_time) then
     stop BMI_FAILURE
  end if
end program test_update
