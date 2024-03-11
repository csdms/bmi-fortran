prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: bmi-fortran
Description: The Basic Model Interface for Fortran
URL: https://bmi.readthedocs.io
Version: @CMAKE_PROJECT_VERSION_MAJOR@.@CMAKE_PROJECT_VERSION_MINOR@
Libs: -L${libdir} -l@CMAKE_PROJECT_NAME@
Cflags: -I${includedir}
