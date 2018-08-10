cmake_minimum_required( VERSION 2.8 )

set( PROJECT_C_PTHREAD c_pthread )
set( PROJECT_C_SEMT c_semt )
set( PROJECT_C_PTHREADMUTEX c_pthreadmutex )

set( PROJECT_CPP_PTHREAD cpp_pthread )
set( PROJECT_CPP_STDASYNC cpp_stdasync )
set( PROJECT_CPP_STDTHREAD cpp_stdthread )
set( PROJECT_CPP_BOOSTTHREAD cpp_boostthread )
set( PROJECT_CPP_SEMT cpp_semt )
set( PROJECT_CPP_PTHREADMUTEX cpp_pthreadmutex )

project( ${PROJECT_C_PTHREAD} )
project( ${PROJECT_C_SEMT} )
project( ${PROJECT_C_PTHREADMUTEX} )

project( ${PROJECT_CPP_PTHREAD} )
project( ${PROJECT_CPP_STDASYNC} )
project( ${PROJECT_CPP_STDTHREAD} )
project( ${PROJECT_CPP_BOOSTTHREAD} )
project( ${PROJECT_CPP_SEMT} )
project( ${PROJECT_CPP_PTHREADMUTEX} )

set( COMMON common_c_cpp )

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread" )

include_directories( ${COMMON} ) 

add_executable( ${PROJECT_C_PTHREAD} ${PROJECT_C_PTHREAD}/${PROJECT_C_PTHREAD}.c ${COMMON}/${COMMON}.c )
add_executable( ${PROJECT_C_SEMT} ${PROJECT_C_SEMT}/${PROJECT_C_SEMT}.c ${COMMON}/${COMMON}.c )
add_executable( ${PROJECT_C_PTHREADMUTEX} ${PROJECT_C_PTHREADMUTEX}/${PROJECT_C_PTHREADMUTEX}.c ${COMMON}/${COMMON}.c )

add_executable( ${PROJECT_CPP_PTHREAD} ${PROJECT_CPP_PTHREAD}/${PROJECT_CPP_PTHREAD}.cpp ${COMMON}/${COMMON}.c )
add_executable( ${PROJECT_CPP_STDASYNC} ${PROJECT_CPP_STDASYNC}/${PROJECT_CPP_STDASYNC}.cpp ${COMMON}/${COMMON}.c )
add_executable( ${PROJECT_CPP_STDTHREAD} ${PROJECT_CPP_STDTHREAD}/${PROJECT_CPP_STDTHREAD}.cpp ${COMMON}/${COMMON}.c )
add_executable( ${PROJECT_CPP_BOOSTTHREAD} ${PROJECT_CPP_BOOSTTHREAD}/${PROJECT_CPP_BOOSTTHREAD}.cpp ${COMMON}/${COMMON}.c )
add_executable( ${PROJECT_CPP_SEMT} ${PROJECT_CPP_SEMT}/${PROJECT_CPP_SEMT}.cpp ${COMMON}/${COMMON}.c )
add_executable( ${PROJECT_CPP_PTHREADMUTEX} ${PROJECT_CPP_PTHREADMUTEX}/${PROJECT_CPP_PTHREADMUTEX}.cpp ${COMMON}/${COMMON}.c )

target_link_libraries( ${PROJECT_C_PTHREAD} pthread )
target_link_libraries( ${PROJECT_C_SEMT} pthread )
target_link_libraries( ${PROJECT_C_PTHREADMUTEX} pthread )

target_link_libraries( ${PROJECT_CPP_PTHREAD} pthread )
target_link_libraries( ${PROJECT_CPP_BOOSTTHREAD} boost_system boost_thread )
target_link_libraries( ${PROJECT_CPP_SEMT} pthread )
target_link_libraries( ${PROJECT_CPP_PTHREADMUTEX} pthread )