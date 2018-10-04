program test_get_var_grid

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: expected_id = 0

  type (bmi_heat) :: m
  integer :: grid_id

  status = m%initialize(config_file)
  status = m%get_var_grid(var_name, grid_id)
  status = m%finalize()

  if (grid_id.ne.expected_id) then
     stop 1
  end if
end program test_get_var_grid
