cmake_minimum_required(VERSION 3.0)

project(bmif Fortran)

add_library(${CMAKE_PROJECT_NAME} SHARED bmi.f90)

install(
  TARGETS ${CMAKE_PROJECT_NAME}
  DESTINATION lib)
install(
  FILES ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}.mod
  DESTINATION include)
