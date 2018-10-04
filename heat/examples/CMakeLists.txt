include(CTest)

include_directories(${CMAKE_Fortran_MODULE_DIRECTORY})

add_test(NAME info_ex COMMAND info_ex)
set(src_info_ex info_ex.f90)
add_executable(info_ex ${src_info_ex})
target_link_libraries(info_ex ${bmi_lib} ${bmiheat_lib})

add_test(NAME irf_ex COMMAND irf_ex)
set(src_irf_ex irf_ex.f90)
add_executable(irf_ex ${src_irf_ex})
target_link_libraries(irf_ex ${bmi_lib} ${bmiheat_lib})

add_test(NAME vargrid_ex COMMAND vargrid_ex)
set(src_vargrid_ex vargrid_ex.f90)
add_executable(vargrid_ex ${src_vargrid_ex})
target_link_libraries(vargrid_ex ${bmi_lib} ${bmiheat_lib})

add_test(NAME get_value_ex COMMAND get_value_ex)
set(src_get_value_ex get_value_ex.f90 testing_helpers.f90)
add_executable(get_value_ex ${src_get_value_ex})
target_link_libraries(get_value_ex ${bmi_lib} ${bmiheat_lib})

add_test(NAME set_value_ex COMMAND set_value_ex)
set(src_set_value_ex set_value_ex.f90 testing_helpers.f90)
add_executable(set_value_ex ${src_set_value_ex})
target_link_libraries(set_value_ex ${bmi_lib} ${bmiheat_lib})

add_test(
  NAME conflicting_instances_ex
  COMMAND conflicting_instances_ex)
set(src_conflicting_instances_ex
  conflicting_instances_ex.f90
  testing_helpers.f90)
add_executable(conflicting_instances_ex ${src_conflicting_instances_ex})
target_link_libraries(conflicting_instances_ex ${bmi_lib} ${bmiheat_lib})
file (
  COPY ${CMAKE_CURRENT_SOURCE_DIR}/test1.cfg
  DESTINATION ${CMAKE_BINARY_DIR}/heat/examples)
file (
  COPY ${CMAKE_CURRENT_SOURCE_DIR}/test2.cfg
  DESTINATION ${CMAKE_BINARY_DIR}/heat/examples)
