cmake_minimum_required(VERSION 2.8)

project(bmi Fortran)

set(bmi_lib bmif)
set(bmiheat_lib bmiheatf)
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/mod)

set(CMAKE_MACOSX_RPATH 1)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

add_subdirectory(bmi)
add_subdirectory(heat)
add_subdirectory(heat/tests)
add_subdirectory(heat/examples)

include(CTest)
