! Test the BMI get_var_* and get_grid_* functions.
program vargrid_test

  use bmiheatf
  implicit none

  type (bmi_heat) :: m
  integer :: s, i
  character (len=BMI_MAXVARNAMESTR), pointer :: names(:)
  integer :: grid_id

  write (*,"(a)",advance="no") "Initializing..."
  s = m%initialize("")
  write (*,*) "Done."

  s = m%get_output_var_names(names)
  write (*,"(a30)") "Output variables:"
  do i = 1, size(names)
     write (*,"(a30, 1x, a)") "-", names(i)
  end do

  s = m%get_var_grid(names(1), grid_id)
  write (*,"(a30, i3)") "Grid id:", grid_id

  write (*,"(a)", advance="no") "Finalizing..."
  s = m%finalize()
  write (*,*) "Done"

end program vargrid_test
