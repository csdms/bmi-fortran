! Run the heat model using its BMI.
program main

  use heatf
  implicit none

  type (heat_model) :: model

  write(*,"(a)") "Start"
  call initialize_from_defaults(model)

  write(*,"(a)") "Model initial values..."
  call print_values(model)

  do while (model%t < model%t_end)
     call advance_in_time(model)
     write(*,"(a, f6.1)") "Model values at time = ", model%t
     call print_values(model)
  end do

  call cleanup(model)
  write(*,"(a)") "Finish"

end program main
