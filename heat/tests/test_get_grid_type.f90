program test_get_grid_type

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  integer, parameter :: grid_id = 0
  character (len=*), parameter :: &
       expected_type = "uniform_rectilinear"

  type (bmi_heat) :: m
  character (len=BMI_MAX_TYPE_NAME) :: grid_type

  status = m%initialize(config_file)
  status = m%get_grid_type(grid_id, grid_type)
  status = m%finalize()

  if (grid_type.ne.expected_type) then
     stop 1
  end if
end program test_get_grid_type
