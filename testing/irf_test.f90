! Test the lifecycle and time BMI methods.
program irf_test

  use bmiheatf
  implicit none

  type (bmi_heat) :: m
  integer :: s

  write (*,"(a)",advance="no") "Initializing..."
  s = m%initialize("")
  write (*,*) "Done."

  write (*,"(a)", advance="no") "Finalizing..."
  s = m%finalize()
  write (*,*) "Done"

end program irf_test
