cmake_minimum_required( VERSION 2.8 )

set( PROJECT_C_PTHREAD c_pthread )

project( ${PROJECT_C_PTHREAD} )

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall" )
set( COMMON_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../common_c_cpp )

include_directories( ${COMMON_PATH} )
add_executable( ${PROJECT_C_PTHREAD} 
	${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_C_PTHREAD}.c
	${COMMON_PATH}/common_c_cpp.c )
target_link_libraries( ${PROJECT_C_PTHREAD} pthread )