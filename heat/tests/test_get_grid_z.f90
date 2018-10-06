program test_get_grid_z

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: grid_id = 1
  integer, parameter :: nz = 1
  real, parameter, dimension(nz) :: expected_z = (/ 0.0 /)

  type (bmi_heat) :: m
  real, dimension(nz) :: grid_z
  integer :: i

  status = m%initialize(config_file)
  status = m%get_grid_z(grid_id, grid_z)
  status = m%finalize()

  print *, grid_z
  print *, expected_z

  do i = 1, nz
     if (grid_z(i).ne.expected_z(i)) then
        stop 1
     end if
  end do
end program test_get_grid_z
