program test_set_value

  use bmiheatf
  use fixtures, only: status, print_array

  implicit none

  character (len=*), parameter :: config_file = "sample.cfg"
  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: rank = 2
  integer, parameter, dimension(rank) :: shape = (/ 10, 5 /)
  integer :: retcode

  retcode = run_test()
  if (retcode.ne.BMI_SUCCESS) then
     stop BMI_FAILURE
  end if

contains

  function run_test() result(code)
    type (bmi_heat) :: m
    real, pointer :: x(:), y(:)
    integer :: i
    integer :: code

    status = m%initialize(config_file)
    status = m%get_value(var_name, x)
    x = 42.0
    status = m%set_value(var_name, x)
    status = m%get_value(var_name, y)
    status = m%finalize()

    ! Visual inspection.
    call print_array(x, shape)
    call print_array(y, shape)

    code = BMI_SUCCESS
    do i = 1, product(shape)
       if (x(i).ne.y(i)) then
          code = BMI_FAILURE
          exit
       end if
    end do

    deallocate(x)
    deallocate(y)
  end function run_test

end program test_set_value
