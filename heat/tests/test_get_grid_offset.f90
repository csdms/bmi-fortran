program test_get_grid_offset

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: grid_id = 1
  integer, parameter :: noffset = 1
  integer, parameter, dimension(noffset) :: expected_offset = (/ 0.0 /)

  type (bmi_heat) :: m
  integer, dimension(noffset) :: grid_offset
  integer :: i

  status = m%initialize(config_file)
  status = m%get_grid_offset(grid_id, grid_offset)
  status = m%finalize()

  print *, grid_offset
  print *, expected_offset

  do i = 1, noffset
     if (grid_offset(i).ne.expected_offset(i)) then
        stop 1
     end if
  end do
end program test_get_grid_offset
