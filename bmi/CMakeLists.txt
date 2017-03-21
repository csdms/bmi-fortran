set(BMI_VERSION 0.3)
set(pkg bmif)
set(mod_name ${pkg})
set(src_${pkg} bmi.f90)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/${pkg}.pc.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/${pkg}.pc)

add_library(${bmi_lib} SHARED ${src_${pkg}})
