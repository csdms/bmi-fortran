! Test the set_value and set_value_at_indices functions.
program set_value_test

  use bmiheatf
  use testing_helpers
  implicit none

  type (bmi_heat) :: m
  integer :: s, i, j, grid_id
  character (len=BMI_MAX_VAR_NAME), pointer :: names(:)
  integer :: dims(2), locations(3)
  real :: values(3)
  real, pointer :: z(:), y(:)
  character(len=30) :: rowfmt

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

  write (*,"(a)",advance="no") "Setting new values..."
  z = 42.0
  s = m%set_value("plate_surface__temperature", z)
  write (*,*) "Done."
  write (*, "(a)") "New values:"
  s = m%get_value("plate_surface__temperature", y)
  call print_array(y, dims)

  write (*, "(a)") "Set values at three locations:"
  locations = [21, 41, 62]
  values = [-1.0, -1.0, -1.0]
  write (*,*) "Locations: ", locations
  write (*,*) "Values: ", values
  s = m%set_value_at_indices("plate_surface__temperature", locations, values)
  write (*, "(a)") "New values:"
  s = m%get_value("plate_surface__temperature", y)
  call print_array(y, dims)

  write (*,"(a)", advance="no") "Finalizing..."
  s = m%finalize()
  write (*,*) "Done"

end program set_value_test
