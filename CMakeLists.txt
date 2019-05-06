cmake_minimum_required(VERSION 3.0)

project(bmif Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/mod)

add_library(${CMAKE_PROJECT_NAME} SHARED bmi.f90)

install(
  TARGETS ${CMAKE_PROJECT_NAME}
  DESTINATION lib)
install(
  FILES ${CMAKE_Fortran_MODULE_DIRECTORY}/${CMAKE_PROJECT_NAME}.mod
  DESTINATION include)
