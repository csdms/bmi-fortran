program test_get_input_var_names

  use bmif, only: BMI_FAILURE, BMI_MAX_VAR_NAME
  use bmiheatf
  use fixtures, only: status

  implicit none

  integer, parameter :: n_inputs = 3
  type (bmi_heat) :: m
  character (len=BMI_MAX_VAR_NAME), allocatable :: expected(:)
  character (len=BMI_MAX_VAR_NAME) :: e1, e2, e3
  character (len=BMI_MAX_VAR_NAME), pointer :: names(:)
  integer :: i

  allocate(expected(n_inputs))
  e1 = "plate_surface__temperature"
  e2 = "plate_surface__thermal_diffusivity"
  e3 = "model__identification_number"
  expected = [e1, e2, e3]
  
  status = m%get_input_var_names(names)

  ! Visualize
  do i = 1, n_inputs
     write(*,*) trim(names(i))
     write(*,*) trim(expected(i))
  end do
  
  do i=1, size(names)
     if (names(i).ne.expected(i)) then
        stop BMI_FAILURE
     end if
  end do
end program test_get_input_var_names
