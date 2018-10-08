program test_get_value_at_indices

  use bmif, only: BMI_SUCCESS, BMI_FAILURE
  use bmiheatf
  use fixtures, only: status, print_array

  implicit none

  character (len=*), parameter :: config_file = "sample.cfg"
  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: rank = 2
  integer, parameter, dimension(rank) :: shape = (/ 10, 5 /)
  integer, parameter, dimension(shape(2)) :: &
       indices = (/ 1, 11, 21, 31, 41 /)
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
    status = m%get_value_at_indices(var_name, tval, indices)
    status = m%finalize()

    ! Visual inspection.
    do i = 1, shape(2)
       write(*,*) indices(i), tval(i), expected(i)
    end do

    code = BMI_SUCCESS
    do i = 1, shape(2)
       if (tval(i).ne.expected(i)) then
          code = BMI_FAILURE
          exit
       end if
    end do

    deallocate(tval)
  end function run_test

end program test_get_value_at_indices
