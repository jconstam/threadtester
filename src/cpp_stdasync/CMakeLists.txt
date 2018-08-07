cmake_minimum_required( VERSION 2.8 )

set( PROJECT_CPP_STDASYNC cpp_stdasync )

project( ${PROJECT_CPP_STDASYNC} )

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread" )
set( COMMON_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../common_c_cpp )

include_directories( ${COMMON_PATH} )
add_executable( ${PROJECT_CPP_STDASYNC}
	${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_CPP_STDASYNC}.cpp
	${COMMON_PATH}/common_c_cpp.c )