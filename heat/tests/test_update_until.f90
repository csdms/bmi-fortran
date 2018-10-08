program test_update_until

  use bmif, only: BMI_FAILURE
  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  real, parameter :: expected_time = 10.0

  type (bmi_heat) :: m
  real :: time

  status = m%initialize(config_file)
  status = m%update_until(expected_time)
  status = m%get_current_time(time)
  status = m%finalize()

  if (time.ne.expected_time) then
     stop BMI_FAILURE
  end if
end program test_update_until
