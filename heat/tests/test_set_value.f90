program test_set_value

  use bmif, only: BMI_SUCCESS, BMI_FAILURE
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

  retcode = test3()
  if (retcode.ne.BMI_SUCCESS) then
     stop BMI_FAILURE
  end if

contains

  function test1() result(code)
    character (len=*), parameter :: &
         var_name = "plate_surface__temperature"
    integer, parameter :: rank = 2
    integer, parameter :: size = 50
    integer, parameter :: shape(rank) = (/ 10, 5 /)
    real :: x(size), y(size)
    integer :: i, code

    status = m%initialize(config_file)
    status = m%get_value(var_name, x)
    x = 42.0
    status = m%set_value(var_name, x)
    status = m%get_value(var_name, y)
    status = m%finalize()

    ! Visual inspection.
    write(*,*) "Test 1"
    call print_array(x, shape)
    call print_array(y, shape)

    code = BMI_SUCCESS
    do i = 1, product(shape)
       if (x(i).ne.y(i)) then
          code = BMI_FAILURE
          exit
       end if
    end do
  end function test1

  function test2() result(code)
    character (len=*), parameter :: &
         var_name = "plate_surface__thermal_diffusivity"
    integer, parameter :: size = 1
    real, parameter :: expected(size) = (/ 0.75 /)
    real :: x(size), y(size)
    integer :: i, code

    status = m%initialize(config_file)
    status = m%get_value(var_name, x)
    status = m%set_value(var_name, expected)
    status = m%get_value(var_name, y)
    status = m%finalize()

    ! Visual inspection.
    write(*,*) "Test 2"
    write(*,*) x
    write(*,*) expected
    write(*,*) y

    code = BMI_SUCCESS
    do i = 1, size
       if (y(i).ne.expected(i)) then
          code = BMI_FAILURE
       end if
    end do
  end function test2

  function test3() result(code)
    character (len=*), parameter :: &
         var_name = "model__identification_number"
    integer, parameter :: size = 1
    integer, parameter :: expected(size) = (/ 42 /)
    integer :: x(size), y(size)
    integer :: i, code

    status = m%initialize(config_file)
    status = m%get_value(var_name, x)
    status = m%set_value(var_name, expected)
    status = m%get_value(var_name, y)
    status = m%finalize()

    ! Visual inspection.
    write(*,*) "Test 3"
    write(*,*) x
    write(*,*) expected
    write(*,*) y

    code = BMI_SUCCESS
    do i = 1, size
       if (y(i).ne.expected(i)) then
          code = BMI_FAILURE
       end if
    end do
  end function test3

end program test_set_value
