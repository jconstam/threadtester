#include <iostream>
#include <cstdlib>
#include <cstring>
#include <ctime>

#include <unistd.h>
#include <pthread.h>

#include "common_c_cpp.h"

static void* start_thread_func( void *arg )
{	
	struct timespec actualStartTime;
	struct timespec* returnedStartTime;

	GetTime( &( actualStartTime ) );
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	returnedStartTime = new struct timespec( );
	memcpy( returnedStartTime, &( actualStartTime ), sizeof( struct timespec ) );
	
	pthread_exit( returnedStartTime );
}

static void* shutdown_thread_func( void *arg )
{	
	struct timespec* endTime;

	endTime = new struct timespec( );
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	GetTime( endTime );
	
	pthread_exit( endTime );
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	
	PARAMS params = getParams( argc, argv );
	
	std::cout << "C++" << std::endl;
	std::cout << "pthread" << std::endl;
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
			struct timespec* startTime;
			
			GetTime( &( preStartTime ) );
			
			pthread_create( &( thread ), NULL, start_thread_func, NULL );
		
			pthread_join( thread, ( void** ) &( startTime ) );
			
			std::cout << GetMicroDiff( &( preStartTime ), startTime ) << std::endl;
			
			delete startTime;
		}
		else if( params.start == DO_END )
		{
			struct timespec postEndTime;
			struct timespec* endTime;
			
			pthread_create( &( thread ), NULL, shutdown_thread_func, NULL );
		
			pthread_join( thread, ( void** ) &( endTime ) );
			
			GetTime( &( postEndTime ) );
			
			std::cout << GetMicroDiff( endTime, &( postEndTime ) ) << std::endl;
			
			delete endTime;
		}
	}
	
	return 0;
}