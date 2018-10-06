Name: heat
Description: An example of the heat equation, with a BMI, in Fortran
Version: ${HEAT_VERSION}
Libs: -L${CMAKE_INSTALL_PREFIX}/lib -l${bmiheat_lib} -l${bmi_lib}
Cflags: -I${CMAKE_INSTALL_PREFIX}/include -std=f2003
