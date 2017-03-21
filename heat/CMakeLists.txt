set(HEAT_VERSION 0.3)
set(pkg heatf)
set(src_${pkg} heat.f90 bmi_heat.f90 main.f90)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/${pkg}.pc.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/${pkg}.pc)

add_library(${bmiheat_lib} SHARED ${src_${pkg}})
target_link_libraries(${bmiheat_lib} ${bmi_lib})

add_executable(run_${pkg} ${src_${pkg}})
target_link_libraries(run_${pkg} ${bmi_lib})
