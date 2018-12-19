set(pkg_name bmif)
set(mod_name ${pkg_name})
set(src_${pkg_name} bmi.f90)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/${pkg_name}.pc.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/${pkg_name}.pc)

add_library(${bmi_lib} SHARED ${src_${pkg_name}})

install(
  TARGETS ${bmi_lib}
  DESTINATION lib
  COMPONENT bmi)
install(
  FILES ${pkg_name}.pc
  DESTINATION lib/pkgconfig)
install(
  FILES ${CMAKE_Fortran_MODULE_DIRECTORY}/${mod_name}.mod
  DESTINATION include)
