configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/${pkg_name}.pc.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/${pkg_name}.pc)

add_library(${CMAKE_PROJECT_NAME} SHARED bmi.f90)

install(
  TARGETS ${CMAKE_PROJECT_NAME}
  DESTINATION lib)
install(
  FILES ${CMAKE_PROJECT_NAME}.pc
  DESTINATION lib/pkgconfig)
install(
  FILES ${CMAKE_Fortran_MODULE_DIRECTORY}/${CMAKE_PROJECT_NAME}.mod
  DESTINATION include)
