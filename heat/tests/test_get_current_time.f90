program test_get_current_time

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: expected_time = 0.0

  type (bmi_heat) :: m
  real :: current_time

  status = m%initialize(config_file)
  status = m%get_current_time(current_time)
  status = m%finalize()

  if (current_time.ne.expected_time) then
     stop 1
  end if
end program test_get_current_time
