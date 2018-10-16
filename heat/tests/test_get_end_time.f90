program test_get_end_time

  use bmif, only: BMI_FAILURE
  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  double precision, parameter :: expected_time = 20.d0

  type (bmi_heat) :: m
  double precision :: end_time

  status = m%initialize(config_file)
  status = m%get_end_time(end_time)
  status = m%finalize()

  if (end_time.ne.expected_time) then
     stop BMI_FAILURE
  end if
end program test_get_end_time
