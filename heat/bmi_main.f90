! Run the heat model through its BMI.
program bmi_main

  use bmiheatf
  implicit none

  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: ndims = 2

  type (bmi_heat) :: model
  integer :: i, j, s, grid_id, grid_size, grid_shape(ndims)
  double precision :: current_time, end_time
  real, allocatable :: temperature(:)

  write(*,"(a)") "Initialize"
  s = model%initialize("")

  s = model%get_current_time(current_time)
  s = model%get_end_time(end_time)
  s = model%get_var_grid(var_name, grid_id)
  s = model%get_grid_size(grid_id, grid_size)
  s = model%get_grid_shape(grid_id, grid_shape)

  allocate(temperature(grid_size))

  do while (current_time <= end_time)
     write(*,"(a, f6.1)") "Model values at time = ", current_time
     s = model%get_value(var_name, temperature)
     do j = 1, grid_shape(1)
        do i = 1, grid_shape(2)
           write (*,"(f6.1)", advance="no") temperature(j + grid_shape(1)*(i-1))
        end do
        write (*,*)
     end do
     s = model%update()
     s = model%get_current_time(current_time)
  end do

  deallocate(temperature)
  s = model%finalize()
  write(*,"(a)") "Finalize"

end program bmi_main
