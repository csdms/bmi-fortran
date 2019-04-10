prefix=${CMAKE_INSTALL_PREFIX}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${exec_prefix}/include

Name: BMI
Description: Basic Model Interface for Fortran
Version: ${bmi_version}
Libs: -L${libdir} -l${CMAKE_PROJECT_NAME}
Cflags: -I${includedir} -std=f2003
