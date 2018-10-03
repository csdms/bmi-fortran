program test_get_value_ref

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
    real, pointer :: tref(:)
    integer :: i, j
    integer :: code

    status = m%initialize(config_file)
    status = m%get_value_ref(var_name, tref)

    ! Visual inspection.
    call print_array(tref, shape)
    do i = 1, shape(2)
       write(*,*) tref((i-1)*shape(1)+1)
    end do

    code = BMI_SUCCESS
    do i = 1, shape(2)
       if (tref((i-1)*shape(1)+1).ne.expected(i)) then
          code = BMI_FAILURE
          exit
       end if
    end do

    status = m%finalize()
  end function run_test

end program test_get_value_ref
