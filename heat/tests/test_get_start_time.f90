program test_get_start_time

  use bmiheatf
  use fixtures

  implicit none

  integer, parameter :: expected_time = 0.0

  type (bmi_heat) :: m
  real :: start_time

  status = m%initialize(config_file)
  status = m%get_start_time(start_time)
  status = m%finalize()

  if (start_time.ne.expected_time) then
     stop 1
  end if
end program test_get_start_time
