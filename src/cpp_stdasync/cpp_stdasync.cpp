#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cstring>
#include <string>
#include <thread>
#include <future>

#include <unistd.h>

#include "common_c_cpp.h"

static struct timespec start_thread_func( )
{	
	struct timespec startTime;

	GetTime( &( startTime ) );
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	return startTime;
}

static struct timespec shutdown_thread_func( )
{	
	struct timespec endTime;
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	GetTime( &( endTime ) );
	
	return endTime;
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	
	PARAMS params = getParams( argc, argv );
	
	std::cout << "C++" << std::endl;
	std::cout << "std::async" << std::endl;
	if( params.start == DO_START )
	{
		std::cout << "thread_start" << std::endl;	
	}
	else if( params.start == DO_END )
	{
		std::cout << "thread_shutdown" << std::endl;
	}
	
	for( i = 0; i < params.count; i++ )
	{
		memset( &( thread ), 0, sizeof( pthread_t ) );
		
		if( params.start == DO_START )
		{
			struct timespec preStartTime;
			struct timespec startTime;
			
			GetTime( &( preStartTime ) );
			auto future = std::async( start_thread_func );
			startTime = future.get( );
			
			std::cout << GetMicroDiff( &( preStartTime ), &( startTime ) ) << std::endl;
		}
		else if( params.start == DO_END )
		{
			struct timespec postEndTime;
			struct timespec endTime;
			
			auto future = std::async( shutdown_thread_func );
			endTime = future.get( );
			
			GetTime( &( postEndTime ) );
			
			std::cout << GetMicroDiff( &( endTime ), &( postEndTime ) ) << std::endl;
		}
	}
	
	return 0;
}