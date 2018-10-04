program test_get_value

  use bmiheatf
  use fixtures, only: status, print_array

  implicit none

  character (len=*), parameter :: config_file = "sample.cfg"
  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: rank = 2
  integer, parameter, dimension(rank) :: shape = (/ 10, 5 /)
  real, parameter, dimension(shape(2)) :: &
       expected = (/ 0.0, 3.0, 4.0, 3.0, 0.0 /)
  integer :: retcode

  retcode = run_test()
  if (retcode.ne.BMI_SUCCESS) then
     stop BMI_FAILURE
  end if

contains

  function run_test() result(code)
    type (bmi_heat) :: m
    real, pointer :: tval(:)
    integer :: i
    integer :: code

    status = m%initialize(config_file)
    status = m%get_value(var_name, tval)
    status = m%finalize()

    ! Visual inspection.
    call print_array(tval, shape)
    do i = 1, shape(2)
       write(*,*) tval((i-1)*shape(1)+1)
    end do

    code = BMI_SUCCESS
    do i = 1, shape(2)
       if (tval((i-1)*shape(1)+1).ne.expected(i)) then
          code = BMI_FAILURE
          exit
       end if
    end do

    deallocate(tval)
  end function run_test

end program test_get_value
