cmake_minimum_required( VERSION 2.8 )

set( PROJECT_CPP_PTHREAD cpp_pthread )

project( ${PROJECT_CPP_PTHREAD} )

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall" )
set( COMMON_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../common_c_cpp )

include_directories( ${COMMON_PATH} )
add_executable( ${PROJECT_CPP_PTHREAD}
	${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_CPP_PTHREAD}.cpp
	${COMMON_PATH}/common_c_cpp.c )
target_link_libraries( ${PROJECT_CPP_PTHREAD} pthread )