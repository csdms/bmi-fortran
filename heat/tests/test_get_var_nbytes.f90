program test_get_var_nbytes

  use bmif, only: BMI_FAILURE
  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: expected_nbytes = 20*10*4

  type (bmi_heat) :: m
  integer :: var_nbytes

  status = m%initialize(config_file)
  status = m%get_var_nbytes(var_name, var_nbytes)
  status = m%finalize()

  if (var_nbytes.ne.expected_nbytes) then
     stop BMI_FAILURE
  end if
end program test_get_var_nbytes
