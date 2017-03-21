! Test the lifecycle and time BMI methods.
program irf_test

  use bmiheatf
  implicit none

  type (bmi_heat) :: m
  integer :: s
  real :: time, time0, time1
  character (len=BMI_MAXUNITSSTR) :: time_units

  write (*,"(a)",advance="no") "Initializing..."
  s = m%initialize("")
  write (*,*) "Done."

  s = m%get_start_time(time0)
  write (*,"(a30, f8.2)") "Start time: ", time0
  s = m%get_end_time(time1)
  write (*,"(a30, f8.2)") "End time: ", time1
  s = m%get_current_time(time)
  write (*,"(a30, f8.2)") "Current time: ", time
  s = m%get_time_step(time)
  write (*,"(a30, f8.2)") "Time step: ", time
  s = m%get_time_units(time_units)
  write (*,"(a30, a10)") "Time units: ", time_units

  write (*,"(a)", advance="no") "Finalizing..."
  s = m%finalize()
  write (*,*) "Done"

end program irf_test
