program test_get_grid_shape

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: grid_id = 0
  integer, parameter :: rank = 2
  integer, dimension(rank), parameter :: expected_shape = [20, 10]

  type (bmi_heat) :: m
  integer, dimension(2) :: grid_shape
  integer :: i

  status = m%initialize(config_file)
  status = m%get_grid_shape(grid_id, grid_shape)
  status = m%finalize()

  do i = 1, rank
     if (grid_shape(i).ne.expected_shape(i)) then
        stop 1
     end if
  end do
end program test_get_grid_shape
