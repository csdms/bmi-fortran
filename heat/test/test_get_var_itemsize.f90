program test_get_var_itemsize

  use bmiheatf

  implicit none

  character (len=*), parameter :: config_file = ""
  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: expected_size = 4

  type (bmi_heat) :: m
  integer :: s
  integer :: item_size

  s = m%initialize(config_file)
  s = m%get_var_itemsize(var_name, item_size)
  s = m%finalize()

  if (item_size.ne.expected_size) then
     stop 1
  end if
end program test_get_var_itemsize
