include(CTest)

include_directories(${CMAKE_Fortran_MODULE_DIRECTORY})

add_test(NAME info_test COMMAND info_test)
set(src_info_test info_test.f90)
add_executable(info_test ${src_info_test})
target_link_libraries(info_test ${bmi_lib} ${bmiheat_lib})

add_test(NAME irf_test COMMAND irf_test)
set(src_irf_test irf_test.f90)
add_executable(irf_test ${src_irf_test})
target_link_libraries(irf_test ${bmi_lib} ${bmiheat_lib})

add_test(NAME vargrid_test COMMAND vargrid_test)
set(src_vargrid_test vargrid_test.f90)
add_executable(vargrid_test ${src_vargrid_test})
target_link_libraries(vargrid_test ${bmi_lib} ${bmiheat_lib})
