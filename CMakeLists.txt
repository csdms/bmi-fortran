cmake_minimum_required(VERSION 3.0)

project(bmif
  VERSION 2.0
  LANGUAGES Fortran
)

# Use system-specific install directories
include(GNUInstallDirs)

# Match the module name set in "bmi.f90".
set(mod_name "${CMAKE_PROJECT_NAME}_\
${CMAKE_PROJECT_VERSION_MAJOR}_${CMAKE_PROJECT_VERSION_MINOR}")

# Create static and shared libraries.
set(static_lib ${CMAKE_PROJECT_NAME}_static)
set(shared_lib ${CMAKE_PROJECT_NAME}_shared)
add_library(${static_lib} bmi.f90)
add_library(${shared_lib} SHARED bmi.f90)

# Change the output names of the libraries. On Windows, they can't
# have the same name, so change the shared library name.
set_target_properties(${static_lib} PROPERTIES
  OUTPUT_NAME ${CMAKE_PROJECT_NAME})
if(WIN32)
  set_target_properties(${shared_lib} PROPERTIES
    OUTPUT_NAME ${CMAKE_PROJECT_NAME}_win)
else()
  set_target_properties(${shared_lib} PROPERTIES
    OUTPUT_NAME ${CMAKE_PROJECT_NAME})
endif()

set_target_properties(${static_lib} PROPERTIES
  VERSION ${CMAKE_PROJECT_VERSION}
)
set_target_properties(${shared_lib} PROPERTIES
  VERSION ${CMAKE_PROJECT_VERSION}
  PUBLIC_HEADER ${CMAKE_BINARY_DIR}/${mod_name}.mod
)

install(
  TARGETS ${static_lib}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(
  TARGETS ${shared_lib}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
