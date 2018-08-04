cmake_minimum_required( VERSION 2.8 )

set( PROJECT_PTHREADS pthread_cpp )

project( ${PROJECT_PTHREADS} )

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall" )

add_executable( ${PROJECT_PTHREADS} pthread_cpp.cpp )
target_link_libraries( ${PROJECT_PTHREADS} pthread )