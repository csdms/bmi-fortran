cmake_minimum_required(VERSION 3.0)

project(bmif Fortran)
set(bmi_major_version 2)
set(bmi_minor_version 0)

# Match the module name set in "bmi.f90".
set(mod_name ${CMAKE_PROJECT_NAME}_${bmi_major_version}_${bmi_minor_version})

# Create static and shared libraries.
add_library(${CMAKE_PROJECT_NAME}_static bmi.f90)
add_library(${CMAKE_PROJECT_NAME}_shared SHARED bmi.f90)

# Change the output names of the libraries. On Windows, they can't
# have the same name, so change the shared library name.
set_target_properties(${CMAKE_PROJECT_NAME}_static PROPERTIES
  OUTPUT_NAME ${CMAKE_PROJECT_NAME})
if(WIN32)
  set_target_properties(${CMAKE_PROJECT_NAME}_shared PROPERTIES
    OUTPUT_NAME ${CMAKE_PROJECT_NAME}_win)
else()
  set_target_properties(${CMAKE_PROJECT_NAME}_shared PROPERTIES
    OUTPUT_NAME ${CMAKE_PROJECT_NAME})
endif()

set_target_properties(${CMAKE_PROJECT_NAME}_static PROPERTIES
  VERSION ${bmi_major_version}.${bmi_minor_version}
)
set_target_properties(${CMAKE_PROJECT_NAME}_shared PROPERTIES
  VERSION ${bmi_major_version}.${bmi_minor_version}
  PUBLIC_HEADER ${CMAKE_BINARY_DIR}/${mod_name}.mod
)

install(
  TARGETS ${CMAKE_PROJECT_NAME}_static
  ARCHIVE DESTINATION lib
)
install(
  TARGETS ${CMAKE_PROJECT_NAME}_shared
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  PUBLIC_HEADER DESTINATION include
)
