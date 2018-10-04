program test_get_var_units

  use bmiheatf
  use fixtures, only: config_file, status

  implicit none

  character (len=*), parameter :: var_name = "plate_surface__temperature"
  character (len=*), parameter :: expected_units = "K"

  type (bmi_heat) :: m
  character (len=BMI_MAX_UNITS_NAME) :: var_units

  status = m%initialize(config_file)
  status = m%get_var_units(var_name, var_units)
  status = m%finalize()

  if (var_units.ne.expected_units) then
     stop 1
  end if
end program test_get_var_units
