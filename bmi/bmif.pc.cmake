Name: BMI
Description: Basic Model Interface for Fortran
Version: ${bmi_version}
Libs: -L${CMAKE_INSTALL_PREFIX}/lib -l${bmi_lib}
Cflags: -I${CMAKE_INSTALL_PREFIX}/include -std=f2003
