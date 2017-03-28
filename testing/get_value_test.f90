! Test the get_value, get_value_ref, and get_value_at_indices functions.
program get_value_test

  use bmiheatf
  use testing_helpers
  implicit none

  type (bmi_heat) :: m
  integer :: s, i, j, grid_id
  character (len=BMI_MAXVARNAMESTR), pointer :: names(:)
  integer :: dims(2), locations(3)
  real, pointer :: z(:), y(:), x(:)
  character(len=30) :: rowfmt
  real :: time

  write (*,"(a)",advance="no") "Initializing..."
  s = m%initialize("")
  write (*,*) "Done."

  s = m%get_output_var_names(names)
  write (*,"(a, a)") "Output variables: ", names

  s = m%get_var_grid(names(1), grid_id)
  s = m%get_grid_shape(grid_id, dims)
  write(rowfmt,'(a,i4,a)') '(', dims(2), '(1x,f6.1))'

  write (*, "(a)") "Initial values:"
  s = m%get_value("plate_surface__temperature", z)
  call print_array(z, dims)
  write (*, "(a, i5)") "Shape of returned values:", shape(z)

  write (*,"(a)") "Running (using get_value)..."
  do j = 1, 4
     s = m%update()
     s = m%get_value("plate_surface__temperature", z)
     s = m%get_current_time(time)
     write (*,"(a, f6.1)") "Current time:", time
     call print_array(z, dims)
  end do
  write (*,"(a)") "Done."

  write (*, "(a)") "Values at three locations:"
  locations = [21, 41, 62]
  write (*,*) "Locations: ", locations
  s = m%get_value_at_indices("plate_surface__temperature", y, locations)
  write (*,*) "Values: ", y

  write (*,"(a)") "Running (using get_value_ref)..."
  s = m%get_value_ref("plate_surface__temperature", x)
  do j = 1, 4
     s = m%update()
     s = m%get_current_time(time)
     write (*,"(a, f6.1)") "Current time:", time
     call print_array(x, dims)
  end do
  write (*,"(a)") "Done."

  write (*,"(a)", advance="no") "Finalizing..."
  s = m%finalize()
  write (*,*) "Done"

end program get_value_test
