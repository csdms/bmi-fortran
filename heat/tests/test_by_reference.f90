program test_by_reference

  use bmiheatf
  use fixtures, only: status, print_array

  implicit none

  character (len=*), parameter :: config_file = "sample.cfg"
  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: grid_id = 0
  integer, parameter :: rank = 2

  type (bmi_heat) :: m
  integer, dimension(rank) :: shape
  real, pointer :: tval(:), tref(:)

  status = m%initialize(config_file)
  status = m%get_grid_shape(grid_id, shape)

  ! Get initial temperature array, by value and by reference.
  status = m%get_value("plate_surface__temperature", tval)
  status = m%get_value_ref("plate_surface__temperature", tref)
  write (*, "(a)") "Time = 0 (by value):"
  call print_array(tval, shape)
  write (*, "(a)") "Time = 0 (by reference):"
  call print_array(tref, shape)

  ! Advance model by a time step and compare tval and tref (they
  ! should differ because tval won't have been updated).
  status = m%update()
  write (*, "(a)") "Time = 1 (by value):"
  call print_array(tval, shape)
  write (*, "(a)") "Time = 1 (by reference):"
  call print_array(tref, shape)
  
  status = m%finalize()

  if (sum(tval).eq.sum(tref)) then
     stop 1
  end if

  deallocate(tval)
end program test_by_reference
