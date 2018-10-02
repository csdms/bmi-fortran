program test_get_input_var_names

  use bmiheatf
  use fixtures, only: status

  implicit none

  type (bmi_heat) :: m
  character (len=BMI_MAX_VAR_NAME), pointer :: names(:)
  integer :: i
  
  status = m%get_input_var_names(names)
  
  do i=1, input_item_count
     if (names(i).ne.input_items(i)) then
        stop 1
     end if
  end do
end program test_get_input_var_names
