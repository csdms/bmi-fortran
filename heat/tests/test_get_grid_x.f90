program test_get_grid_x

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: grid_id = 1
  integer, parameter :: nx = 1
  real, parameter, dimension(nx) :: expected_x = (/ 0.0 /)

  type (bmi_heat) :: m
  real, dimension(nx) :: grid_x
  integer :: i

  status = m%initialize(config_file)
  status = m%get_grid_x(grid_id, grid_x)
  status = m%finalize()

  print *, grid_x
  print *, expected_x

  do i = 1, nx
     if (grid_x(i).ne.expected_x(i)) then
        stop 1
     end if
  end do
end program test_get_grid_x
