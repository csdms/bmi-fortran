program test_get_value

  use bmiheatf
  use fixtures, only: status, print_array

  implicit none

  character (len=*), parameter :: config_file = "sample.cfg"
  type (bmi_heat) :: m
  integer :: retcode

  retcode = test1()
  if (retcode.ne.BMI_SUCCESS) then
     stop BMI_FAILURE
  end if

  retcode = test2()
  if (retcode.ne.BMI_SUCCESS) then
     stop BMI_FAILURE
  end if

contains

  function test1() result(code)
    character (len=*), parameter :: &
         var_name = "plate_surface__temperature"
    integer, parameter :: rank = 2
    integer, parameter, dimension(rank) :: shape = (/ 10, 5 /)
    real, parameter, dimension(shape(2)) :: &
         expected = (/ 0.0, 3.0, 4.0, 3.0, 0.0 /)
    real, pointer :: tval(:)
    integer :: i, code

    status = m%initialize(config_file)
    status = m%get_value(var_name, tval)
    status = m%finalize()

    ! Visual inspection.
    write(*,*) "Test 1"
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
  end function test1

  function test2() result(code)
    character (len=*), parameter :: &
         var_name = "plate_surface__thermal_diffusivity"
    real, parameter :: expected = 1.0
    real, pointer :: val(:)
    integer :: i, code

    status = m%initialize(config_file)
    status = m%get_value(var_name, val)
    status = m%finalize()

    ! Visual inspection.
    write(*,*) "Test 2"
    write(*,*) val
    write(*,*) expected

    code = BMI_SUCCESS
    if (val(1).ne.expected) then
       code = BMI_FAILURE
    end if

    deallocate(val)
  end function test2
  
end program test_get_value
