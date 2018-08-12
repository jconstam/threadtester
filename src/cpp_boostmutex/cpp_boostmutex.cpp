#include <iostream>
#include <cstdlib>
#include <cstring>
#include <ctime>

#include <unistd.h>

#include <boost/interprocess/sync/interprocess_mutex.hpp>
#include <boost/interprocess/sync/interprocess_recursive_mutex.hpp>

#include "common_c_cpp.h"

static void* sem_thread_func( void* arg )
{	
	struct timespec actualAfterWaitTime;
	struct timespec* returnedAfterWaitTime;
	
	( ( boost::interprocess::interprocess_mutex* ) arg )->lock( );

	GetTime( &( actualAfterWaitTime ) );
	
	returnedAfterWaitTime = new struct timespec( );
	memcpy( returnedAfterWaitTime, &( actualAfterWaitTime ), sizeof( struct timespec ) );
	
	( ( boost::interprocess::interprocess_mutex* ) arg )->unlock( );
	
	pthread_exit( returnedAfterWaitTime );
}

static void* sem_thread_func_recursive( void* arg )
{	
	struct timespec actualAfterWaitTime;
	struct timespec* returnedAfterWaitTime;
	
	( ( boost::interprocess::interprocess_recursive_mutex* ) arg )->lock( );

	GetTime( &( actualAfterWaitTime ) );
	
	returnedAfterWaitTime = new struct timespec( );
	memcpy( returnedAfterWaitTime, &( actualAfterWaitTime ), sizeof( struct timespec ) );
	
	( ( boost::interprocess::interprocess_recursive_mutex* ) arg )->unlock( );
	
	pthread_exit( returnedAfterWaitTime );
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	
	PARAMS params = getParams( argc, argv );
	
	std::cout << "C++" << std::endl;
	if( params.start == DO_START )
	{
		std::cout << "boost_mutex_fast" << std::endl;
		std::cout << "sem_unlock" << std::endl;
		boost::interprocess::interprocess_mutex mutex;
	
		for( i = 0; i < params.count; i++ )
		{
			mutex.lock( );
		
			memset( &( thread ), 0, sizeof( pthread_t ) );
			
			struct timespec postTime;
			struct timespec* afterWaitTime;
			
			pthread_create( &( thread ), NULL, sem_thread_func, &( mutex ) );
			
			usleep( THREAD_MIN_ALIVE_TIME_US );
			
			GetTime( &( postTime ) );
			mutex.unlock( );
		
			pthread_join( thread, ( void** ) &( afterWaitTime ) );
			
			std::cout << GetMicroDiff( &( postTime ), afterWaitTime ) << std::endl;
			
			delete afterWaitTime;
		}
	}
	else if( params.start == DO_END )
	{
		std::cout << "pthread_mutex_recursive" << std::endl;
		std::cout << "sem_unlock" << std::endl;
		boost::interprocess::interprocess_recursive_mutex mutex;
	
		for( i = 0; i < params.count; i++ )
		{
			mutex.lock( );
		
			memset( &( thread ), 0, sizeof( pthread_t ) );
			
			struct timespec postTime;
			struct timespec* afterWaitTime;
			
			pthread_create( &( thread ), NULL, sem_thread_func_recursive, &( mutex ) );
			
			usleep( THREAD_MIN_ALIVE_TIME_US );
			
			GetTime( &( postTime ) );
			mutex.unlock( );
		
			pthread_join( thread, ( void** ) &( afterWaitTime ) );
			
			std::cout << GetMicroDiff( &( postTime ), afterWaitTime ) << std::endl;
			
			delete afterWaitTime;
		}
	}
	
	return 0;
}