cmake_minimum_required( VERSION 2.8 )

set( PROJECT_PTHREADS pthread_c )

project( ${PROJECT_PTHREADS} )

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall" )

add_executable( ${PROJECT_PTHREADS} pthread_c.c )
target_link_libraries( ${PROJECT_PTHREADS} pthread )