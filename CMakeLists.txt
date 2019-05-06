cmake_minimum_required(VERSION 3.0)

project(bmif Fortran)
set(bmi_major_version 1)
set(bmi_minor_version 2)

add_library(${CMAKE_PROJECT_NAME} SHARED bmi.f90)
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
  VERSION ${bmi_major_version}.${bmi_minor_version}
)

install(
  TARGETS ${CMAKE_PROJECT_NAME}
  DESTINATION lib)
install(
  FILES ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}_${bmi_major_version}_${bmi_minor_version}.mod
  DESTINATION include)
