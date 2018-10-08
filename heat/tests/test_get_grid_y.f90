program test_get_grid_y

  use bmif, only: BMI_FAILURE
  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: grid_id = 1
  integer, parameter :: ny = 1
  real, parameter, dimension(ny) :: expected_y = (/ 0.0 /)

  type (bmi_heat) :: m
  real, dimension(ny) :: grid_y
  integer :: i

  status = m%initialize(config_file)
  status = m%get_grid_y(grid_id, grid_y)
  status = m%finalize()

  print *, grid_y
  print *, expected_y

  do i = 1, ny
     if (grid_y(i).ne.expected_y(i)) then
        stop BMI_FAILURE
     end if
  end do
end program test_get_grid_y
