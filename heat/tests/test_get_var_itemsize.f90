program test_get_var_itemsize

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: expected_size = 4

  type (bmi_heat) :: m
  integer :: item_size

  status = m%initialize(config_file)
  status = m%get_var_itemsize(var_name, item_size)
  status = m%finalize()

  if (item_size.ne.expected_size) then
     stop 1
  end if
end program test_get_var_itemsize
