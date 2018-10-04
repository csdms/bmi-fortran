program test_get_end_time

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: expected_time = 20.0

  type (bmi_heat) :: m
  real :: end_time

  status = m%initialize(config_file)
  status = m%get_end_time(end_time)
  status = m%finalize()

  if (end_time.ne.expected_time) then
     stop 1
  end if
end program test_get_end_time
