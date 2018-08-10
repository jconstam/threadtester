#include <iostream>
#include <cstdlib>
#include <cstring>
#include <ctime>

#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

#include "common_c_cpp.h"

static void* sem_thread_func( void* arg )
{	
	struct timespec actualAfterWaitTime;
	struct timespec* returnedAfterWaitTime;
	
	sem_wait( ( sem_t* ) arg );

	GetTime( &( actualAfterWaitTime ) );
	
	returnedAfterWaitTime = new struct timespec( );
	memcpy( returnedAfterWaitTime, &( actualAfterWaitTime ), sizeof( struct timespec ) );
	
	sem_post( ( sem_t* ) arg );
	
	pthread_exit( returnedAfterWaitTime );
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	sem_t semaphore;
	
	PARAMS params = getParams( argc, argv );
	
	sem_init( &( semaphore ), 0, 1 );
	
	std::cout << "C++" << std::endl;
	std::cout << "semt" << std::endl;
	std::cout << "sem_unlock" << std::endl;
	
	for( i = 0; i < params.count; i++ )
	{
		sem_wait( &( semaphore ) );
	
		memset( &( thread ), 0, sizeof( pthread_t ) );
		
		struct timespec postTime;
		struct timespec* afterWaitTime;
		
		pthread_create( &( thread ), NULL, sem_thread_func, &( semaphore ) );
		
		usleep( THREAD_MIN_ALIVE_TIME_US );
		
		GetTime( &( postTime ) );
		sem_post( &( semaphore ) );
	
		pthread_join( thread, ( void** ) &( afterWaitTime ) );
		
		std::cout << GetMicroDiff( &( postTime ), afterWaitTime ) << std::endl;
		
		delete afterWaitTime;
	}
	
	return 0;
}