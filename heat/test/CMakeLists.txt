include(CTest)

include_directories(${CMAKE_Fortran_MODULE_DIRECTORY})

set(test1 test_get_var_itemsize)
add_test(NAME ${test1} COMMAND ${test1})
set(src_${test1} ${test1}.f90)
add_executable(${test1} ${src_${test1}})
target_link_libraries(${test1} ${bmi_lib} ${bmiheat_lib})
