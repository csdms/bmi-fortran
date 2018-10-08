program test_initialize

  use bmif, only: BMI_SUCCESS
  use bmiheatf
  use fixtures, only: status

  implicit none

  character (len=*), parameter :: config_file1 = ""
  character (len=*), parameter :: config_file2 = "sample.cfg"

  type (bmi_heat) :: m
  integer :: status1, status2

  status1 = m%initialize(config_file1)
  status = m%finalize()
  if (status1.ne.BMI_SUCCESS) then
     stop 1
  end if

  status2 = m%initialize(config_file2)
  status = m%finalize()
  if (status2.ne.BMI_SUCCESS) then
     stop 2
  end if
end program test_initialize
