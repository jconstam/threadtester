cmake_minimum_required( VERSION 2.8 )

set( CMAKE_VERBOSE_MAKEFILE TRUE )

set( PROJECT_CPP_STDTHREAD cpp_stdthread )

project( ${PROJECT_CPP_STDTHREAD} )

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread" )

add_executable( ${PROJECT_CPP_STDTHREAD} ${PROJECT_CPP_STDTHREAD}.cpp )