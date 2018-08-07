#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cstring>
#include <string>
#include <thread>
#include <future>

#include <unistd.h>

#include "common_c_cpp.h"

static void start_thread_func( std::promise<struct timespec> && promise )
{	
	struct timespec startTime;

	GetTime( &( startTime ) );
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	promise.set_value( startTime );
}

static void shutdown_thread_func( std::promise<struct timespec> && promise )
{	
	struct timespec endTime;
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	GetTime( &( endTime ) );
	
	promise.set_value( endTime );
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	
	PARAMS params = getParams( argc, argv );
	
	std::cout << "C++" << std::endl;
	std::cout << "std::thread" << std::endl;
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
			std::promise< struct timespec > promise;
			auto future = promise.get_future( );
			
			GetTime( &( preStartTime ) );
			std::thread thread( &( start_thread_func ), std::move( promise ) );
			
			thread.join( );
			startTime = future.get( );
			
			std::cout << GetMicroDiff( &( preStartTime ), &( startTime ) ) << std::endl;
		}
		else if( params.start == DO_END )
		{
			struct timespec postEndTime;
			struct timespec endTime;
			std::promise< struct timespec > promise;
			auto future = promise.get_future( );
			
			std::thread thread( &( shutdown_thread_func ), std::move( promise ) );
			
			thread.join( );
			GetTime( &( postEndTime ) );
			endTime = future.get( );
			
			std::cout << GetMicroDiff( &( endTime ), &( postEndTime ) ) << std::endl;
		}
	}
	
	return 0;
}