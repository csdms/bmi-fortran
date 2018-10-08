program test_finalize

  use bmif, only: BMI_SUCCESS, BMI_FAILURE
  use bmiheatf
  use fixtures, only: status, config_file

  implicit none

  type (bmi_heat) :: m
  integer :: status1

  status = m%initialize(config_file)
  status1 = m%finalize()
  if (status1.ne.BMI_SUCCESS) then
     stop BMI_FAILURE
  end if
end program test_finalize
