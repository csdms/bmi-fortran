cmake_minimum_required(VERSION 2.8)

project(bmi Fortran)

set(bmi_lib bmif)
set(bmiheat_lib bmiheatf)
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/mod)

add_subdirectory(bmi)
add_subdirectory(heat)
