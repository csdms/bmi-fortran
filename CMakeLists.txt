cmake_minimum_required(VERSION 3.12)

project(bmif
  VERSION 2.0.2
  LANGUAGES Fortran
)

# Use system-specific install directories
include(GNUInstallDirs)

# Match the module name set in "bmi.f90".
set(mod_name "${CMAKE_PROJECT_NAME}_\
${CMAKE_PROJECT_VERSION_MAJOR}_${CMAKE_PROJECT_VERSION_MINOR}")

configure_file(
  ${CMAKE_SOURCE_DIR}/${CMAKE_PROJECT_NAME}.pc.cmake
  ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}.pc
  @ONLY
)

# Create shared and static libraries through an object library.
set(shared_lib ${CMAKE_PROJECT_NAME}_shared)
set(static_lib ${CMAKE_PROJECT_NAME}_static)
add_library(obj_lib OBJECT bmi.f90)
add_library(${shared_lib} SHARED $<TARGET_OBJECTS:obj_lib>)
add_library(${static_lib} STATIC $<TARGET_OBJECTS:obj_lib>)

set_target_properties(${shared_lib}
  PROPERTIES
  OUTPUT_NAME ${CMAKE_PROJECT_NAME}
  VERSION ${CMAKE_PROJECT_VERSION}
  PUBLIC_HEADER ${CMAKE_BINARY_DIR}/${mod_name}.mod
)

set_target_properties(${static_lib}
  PROPERTIES
  OUTPUT_NAME ${CMAKE_PROJECT_NAME}
  VERSION ${CMAKE_PROJECT_VERSION}
)
if(WIN32)
  set_target_properties(${static_lib}
    PROPERTIES
    OUTPUT_NAME ${CMAKE_PROJECT_NAME}_static
  )
endif()

install(
  TARGETS ${shared_lib}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
install(
  TARGETS ${static_lib}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(
  FILES ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)
