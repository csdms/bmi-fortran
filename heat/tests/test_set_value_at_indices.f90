program test_set_value_at_indices

  use bmiheatf
  use fixtures, only: status, print_array

  implicit none

  character (len=*), parameter :: config_file = "sample.cfg"
  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: rank = 2
  integer, parameter, dimension(rank) :: shape = (/ 10, 5 /)
  integer, parameter, dimension(shape(2)) :: &
       indices = (/ 2, 12, 22, 32, 42 /)
  real, parameter, dimension(shape(2)) :: &
       expected = (/ 17.0, 42.0, 88.0, 42.0, 17.0 /)
  integer :: retcode

  retcode = run_test()
  if (retcode.ne.BMI_SUCCESS) then
     stop BMI_FAILURE
  end if

contains

  function run_test() result(code)
    type (bmi_heat) :: m
    real, pointer :: x(:)
    integer :: i
    integer :: code

    status = m%initialize(config_file)
    status = m%set_value_at_indices(var_name, indices, expected)
    status = m%get_value(var_name, x)
    status = m%finalize()

    ! Visual inspection.
    do i = 1, shape(2)
       write(*,*) indices(i), x(indices(i)), expected(i)
    end do

    code = BMI_SUCCESS
    do i = 1, shape(2)
       if (x(indices(i)).ne.expected(i)) then
          code = BMI_FAILURE
          exit
       end if
    end do

    deallocate(x)
  end function run_test

end program test_set_value_at_indices
