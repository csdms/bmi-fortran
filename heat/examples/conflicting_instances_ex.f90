! Do two instances of bmi_heat conflict?
program conflicting_instances_ex

  use bmif, only: BMI_MAX_VAR_NAME
  use bmiheatf
  use testing_helpers
  implicit none

  type (bmi_heat) :: m1
  type (bmi_heat) :: m2
  character (len=BMI_MAX_VAR_NAME) :: &
       cfg_file1 = "test1.cfg", cfg_file2 = "test2.cfg"
  integer :: s
  integer :: grid_id1, grid_id2
  character (len=BMI_MAX_VAR_NAME), pointer :: names1(:), names2(:)
  integer :: grid_size1, grid_size2, dims1(2), dims2(2)
  real, allocatable :: z1(:), z2(:)
  character(len=30) :: rowfmt1, rowfmt2

  write(*, "(a, a10, a10)") "Configuration files: ", cfg_file1, cfg_file2

  write (*,"(a)",advance="no") "Initializing..."
  s = m1%initialize(cfg_file1)
  s = m2%initialize(cfg_file2)
  write (*,*) "Done."

  s = m1%get_output_var_names(names1)
  s = m1%get_var_grid(names1(1), grid_id1)
  s = m1%get_grid_shape(grid_id1, dims1)
  s = m1%get_grid_size(grid_id1, grid_size1)
  write(rowfmt1,'(a,i4,a)') '(', dims1(2), '(1x,f6.1))'

  write (*, "(a)") "Initial values, model 1:"
  allocate(z1(grid_size1))
  s = m1%get_value("plate_surface__temperature", z1)
  call print_array(z1, dims1)

  s = m2%get_output_var_names(names2)
  s = m2%get_var_grid(names2(1), grid_id2)
  s = m2%get_grid_shape(grid_id2, dims2)
  s = m2%get_grid_size(grid_id2, grid_size2)
  write(rowfmt2,'(a,i4,a)') '(', dims2(2), '(1x,f6.1))'

  write (*, "(a)") "Initial values, model 2:"
  allocate(z2(grid_size2))
  s = m2%get_value("plate_surface__temperature", z2)
  call print_array(z2, dims2)

  write (*, "(a)") "Set new value in model 2; does it affect model 1?"
  s = m2%set_value_at_indices("plate_surface__temperature", [20], [42.0])
  write (*, "(a)") "New values, model 2:"
  s = m2%get_value("plate_surface__temperature", z2)
  call print_array(z2, dims2)
  write (*, "(a)") "New values, model 1:"
  s = m1%get_value("plate_surface__temperature", z1)
  call print_array(z1, dims1)

  write (*, "(a)") "Update both models by one time step..."
  s = m1%update()
  s = m2%update()
  write (*, "(a)") "Updated values, model 1:"
  s = m1%get_value("plate_surface__temperature", z1)
  call print_array(z1, dims1)
  write (*, "(a)") "Updated values, model 2:"
  s = m2%get_value("plate_surface__temperature", z2)
  call print_array(z2, dims2)

  write (*,"(a)", advance="no") "Finalizing..."
  deallocate(z1, z2)
  s = m1%finalize()
  s = m2%finalize()
  write (*,*) "Done"

end program conflicting_instances_ex
