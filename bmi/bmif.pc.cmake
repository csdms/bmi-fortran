Name: BMI
Description: Basic Model Interface for Fortran
Version: ${BMI_VERSION}
Libs: -L${CMAKE_INSTALL_PREFIX}/lib -l${bmi_lib}
Cflags: -I${CMAKE_INSTALL_PREFIX}/include -std=f2003
