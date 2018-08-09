#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <semaphore.h>

#include "common_c_cpp.h"

static void* sem_thread_func( void* arg )
{	
	struct timespec actualAfterWaitTime;
	struct timespec* returnedAfterWaitTime;
	
	sem_wait( ( sem_t* ) arg );

	GetTime( &( actualAfterWaitTime ) );
	
	returnedAfterWaitTime = calloc( 1, sizeof( struct timespec ) );
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
	
	printf( "C\n" );
	printf( "semt\n" );
	printf( "sem_unlock\n" );
	
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
		
		printf( "%f\n", GetMicroDiff( &( postTime ), afterWaitTime ) );
		
		free( afterWaitTime );
	}
	
	return 0;
}