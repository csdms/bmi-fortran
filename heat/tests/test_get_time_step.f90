program test_get_time_step

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: expected_time_step = 1.0

  type (bmi_heat) :: m
  real :: time_step

  status = m%initialize(config_file)
  status = m%get_time_step(time_step)
  status = m%finalize()

  if (time_step.ne.expected_time_step) then
     stop 1
  end if
end program test_get_time_step
