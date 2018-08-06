cmake_minimum_required( VERSION 2.8 )

set( PROJECT_CPP_STDASYNC cpp_stdasync )

project( ${PROJECT_CPP_STDASYNC} )

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread" )

add_executable( ${PROJECT_CPP_STDASYNC} ${PROJECT_CPP_STDASYNC}.cpp )