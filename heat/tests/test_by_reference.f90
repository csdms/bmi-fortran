program test_by_reference

  use bmif, only: BMI_SUCCESS, BMI_FAILURE
  use bmiheatf
  use fixtures, only: status, print_array

  implicit none

  character (len=*), parameter :: config_file = "sample.cfg"
  character (len=*), parameter :: var_name = "plate_surface__temperature"
  integer, parameter :: grid_id = 0
  integer, parameter :: rank = 2
  integer :: retcode

  retcode = run_test()
  if (retcode.ne.BMI_SUCCESS) then
     stop BMI_FAILURE
  end if

contains

  function run_test() result(code)
    type (bmi_heat) :: m
    integer, dimension(rank) :: shape
    integer :: size
    real, allocatable :: tval(:)
    real, pointer :: tref(:)
    integer :: code

    status = m%initialize(config_file)
    status = m%get_grid_shape(grid_id, shape)
    status = m%get_grid_size(grid_id, size)

    ! Dynamically allocate memory for the temperature values.
    allocate(tval(size))

    ! Get initial temperature array, by value and by reference.
    status = m%get_value("plate_surface__temperature", tval)
    status = m%get_value_ref("plate_surface__temperature", tref)
    write (*, "(a)") "Time = 0 (by value):"
    call print_array(tval, shape)
    write (*, "(a)") "Time = 0 (by reference):"
    call print_array(tref, shape)

    ! Advance model by a time step and compare tval and tref (they
    ! should differ because tval won't have been updated).
    status = m%update()
    write (*, "(a)") "Time = 1 (by value):"
    call print_array(tval, shape)
    write (*, "(a)") "Time = 1 (by reference):"
    call print_array(tref, shape)
  
    code = BMI_SUCCESS
    if (sum(tval).eq.sum(tref)) then
       code = BMI_FAILURE
    end if

    status = m%finalize()
    deallocate(tval)
  end function run_test

end program test_by_reference
