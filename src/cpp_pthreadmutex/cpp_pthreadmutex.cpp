#include <iostream>
#include <cstdlib>
#include <cstring>
#include <ctime>

#include <unistd.h>
#include <pthread.h>

#include "common_c_cpp.h"

static void* sem_thread_func( void* arg )
{	
	struct timespec actualAfterWaitTime;
	struct timespec* returnedAfterWaitTime;
	
	pthread_mutex_lock( ( pthread_mutex_t* ) arg );

	GetTime( &( actualAfterWaitTime ) );
	
	returnedAfterWaitTime = new struct timespec( );
	memcpy( returnedAfterWaitTime, &( actualAfterWaitTime ), sizeof( struct timespec ) );
	
	pthread_mutex_unlock( ( pthread_mutex_t* ) arg );
	
	pthread_exit( returnedAfterWaitTime );
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	pthread_mutex_t mutex;
	pthread_mutexattr_t mutexAttr;
	
	PARAMS params = getParams( argc, argv );
	
	pthread_mutexattr_init( &( mutexAttr ) );
	
	std::cout << "C++" << std::endl;
	if( params.start == DO_START )
	{
		pthread_mutexattr_settype( &( mutexAttr ), PTHREAD_MUTEX_NORMAL );
		std::cout << "pthread_mutex_fast" << std::endl;
	}
	else if( params.start == DO_END )
	{
		pthread_mutexattr_settype( &( mutexAttr ), PTHREAD_MUTEX_RECURSIVE );
		std::cout << "pthread_mutex_recursive" << std::endl;
	}
	std::cout << "sem_unlock" << std::endl;
	
	pthread_mutex_init( &( mutex ), &( mutexAttr ) );
	
	for( i = 0; i < params.count; i++ )
	{
		pthread_mutex_lock( &( mutex ) );
	
		memset( &( thread ), 0, sizeof( pthread_t ) );
		
		struct timespec postTime;
		struct timespec* afterWaitTime;
		
		pthread_create( &( thread ), NULL, sem_thread_func, &( mutex ) );
		
		usleep( THREAD_MIN_ALIVE_TIME_US );
		
		GetTime( &( postTime ) );
		pthread_mutex_unlock( &( mutex ) );
	
		pthread_join( thread, ( void** ) &( afterWaitTime ) );
		
		std::cout << GetMicroDiff( &( postTime ), afterWaitTime ) << std::endl;
		
		delete afterWaitTime;
	}
	
	return 0;
}