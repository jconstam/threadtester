cmake_minimum_required( VERSION 2.8 )

set( PROJECT_C_PTHREAD c_pthread )

project( ${PROJECT_C_PTHREAD} )

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall" )

add_executable( ${PROJECT_C_PTHREAD} ${PROJECT_C_PTHREAD}.c )
target_link_libraries( ${PROJECT_C_PTHREAD} pthread )