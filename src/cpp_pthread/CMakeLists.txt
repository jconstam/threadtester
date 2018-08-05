cmake_minimum_required( VERSION 2.8 )

set( PROJECT_CPP_PTHREAD cpp_pthread )

project( ${PROJECT_CPP_PTHREAD} )

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall" )

add_executable( ${PROJECT_CPP_PTHREAD} ${PROJECT_CPP_PTHREAD}.cpp )
target_link_libraries( ${PROJECT_CPP_PTHREAD} pthread )