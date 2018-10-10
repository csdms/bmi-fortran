program test_get_output_var_names

  use bmif, only: BMI_FAILURE, BMI_MAX_VAR_NAME
  use bmiheatf
  use fixtures, only: status

  implicit none

  integer, parameter :: n_outputs = 1
  character (len=*), parameter, dimension(n_outputs) :: &
       expected = (/ "plate_surface__temperature" /)

  type (bmi_heat) :: m
  character (len=BMI_MAX_VAR_NAME), pointer :: names(:)
  integer :: i
  
  status = m%get_output_var_names(names)

  ! Visualize
  write(*,*) names
  write(*,*) expected
  
  do i=1, size(names)
     if (names(i).ne.expected(i)) then
        stop BMI_FAILURE
     end if
  end do
end program test_get_output_var_names
