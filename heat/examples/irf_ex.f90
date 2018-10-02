! Test the lifecycle and time BMI methods.
program irf_test

  use bmiheatf
  implicit none

  type (bmi_heat) :: m
  integer :: s, i
  real :: time, time0, time1
  character (len=BMI_MAX_UNITS_NAME) :: time_units

  write (*,"(a)",advance="no") "Initializing..."
  s = m%initialize("")
  write (*,*) "Done."

  s = m%get_start_time(time0)
  write (*,"(a30, f8.2)") "Start time:", time0
  s = m%get_end_time(time1)
  write (*,"(a30, f8.2)") "End time:", time1
  s = m%get_current_time(time)
  write (*,"(a30, f8.2)") "Current time:", time
  s = m%get_time_step(time)
  write (*,"(a30, f8.2)") "Time step:", time
  s = m%get_time_units(time_units)
  write (*,"(a30, 1x, a10)") "Time units:", time_units

  write (*,"(a)") "Update one time step"
  s = m%get_current_time(time)
  write (*,"(a30, f8.2)") "Start time:", time
  s = m%update()
  s = m%get_current_time(time)
  write (*,"(a30, f8.2)") "Stop time:", time

  write (*,"(a)") "Running"
  do i = 1, 10
     s = m%update()
     s = m%get_current_time(time)
     write (*,"(a30, f8.2)") "Time:", time
  end do

  write (*,"(a)") "Update a fraction of a time step"
  s = m%get_current_time(time0)
  write (*,"(a30, f8.2)") "Start time: ", time0
  s = m%update_frac(0.5)
  s = m%get_current_time(time1)
  write (*,"(a30, f8.2)") "Stop time: ", time1

  s = m%get_end_time(time)
  write (*,"(a, f8.2)") "Running until... ", time
  s = m%get_current_time(time0)
  write (*,"(a30, f8.2)") "Start time: ", time0
  s = m%update_until(time)
  s = m%get_current_time(time1)
  write (*,"(a30, f8.2)") "Stop time: ", time1

  write (*,"(a)", advance="no") "Finalizing..."
  s = m%finalize()
  write (*,*) "Done"

end program irf_test
