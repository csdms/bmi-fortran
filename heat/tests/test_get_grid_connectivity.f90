program test_get_grid_connectivity

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: grid_id = 1
  integer, parameter :: nconnectivity = 1
  integer, parameter, dimension(nconnectivity) :: &
       expected_connectivity = (/ 0.0 /)

  type (bmi_heat) :: m
  integer, dimension(nconnectivity) :: grid_connectivity
  integer :: i

  status = m%initialize(config_file)
  status = m%get_grid_connectivity(grid_id, grid_connectivity)
  status = m%finalize()

  print *, grid_connectivity
  print *, expected_connectivity

  do i = 1, nconnectivity
     if (grid_connectivity(i).ne.expected_connectivity(i)) then
        stop 1
     end if
  end do
end program test_get_grid_connectivity
