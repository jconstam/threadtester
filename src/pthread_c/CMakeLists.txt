cmake_minimum_required( VERSION 2.8 )

set( PROJECT_PTHREADS pthread_c )

project( ${PROJECT_PTHREADS} )

add_executable( ${PROJECT_PTHREADS} pthread_c.c )
target_link_libraries( ${PROJECT_PTHREADS} pthread )