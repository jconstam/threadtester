#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cstring>
#include <string>

#define BOOST_THREAD_PROVIDES_FUTURE
#include <boost/thread.hpp>
#include <boost/thread/future.hpp>

#include <unistd.h>

#include "common_c_cpp.h"

static void start_thread_func( boost::promise<struct timespec> &promise )
{	
	struct timespec startTime;

	GetTime( &( startTime ) );
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	promise.set_value( startTime );
}

static void shutdown_thread_func( boost::promise<struct timespec> &promise )
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
	std::cout << "boost::thread" << std::endl;
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
			
			boost::promise<struct timespec> p;
			boost::future<struct timespec> f = p.get_future();
			
			GetTime( &( preStartTime ) );
			boost::thread t{ start_thread_func, std::ref( p ) };
			
			t.join( );
			startTime = f.get( );
			
			std::cout << GetMicroDiff( &( preStartTime ), &( startTime ) ) << std::endl;
		}
		else if( params.start == DO_END )
		{
			struct timespec endTime;
			struct timespec postEndTime;
			
			boost::promise<struct timespec> p;
			boost::future<struct timespec> f = p.get_future();
			
			boost::thread t{ shutdown_thread_func, std::ref( p ) };
			
			t.join( );
			GetTime( &( postEndTime ) );
			endTime = f.get( );
			
			std::cout << GetMicroDiff( &( endTime ), &( postEndTime ) ) << std::endl;
		}
	}
	
	return 0;
}