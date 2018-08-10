#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <pthread.h>

#include "common_c_cpp.h"

static void* sem_thread_func( void* arg )
{	
	struct timespec actualAfterWaitTime;
	struct timespec* returnedAfterWaitTime;
	
	pthread_mutex_lock( ( pthread_mutex_t* ) arg );

	GetTime( &( actualAfterWaitTime ) );
	
	returnedAfterWaitTime = calloc( 1, sizeof( struct timespec ) );
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
	
	printf( "C\n" );
	if( params.start == DO_START )
	{
		pthread_mutexattr_settype( &( mutexAttr ), PTHREAD_MUTEX_NORMAL );
		printf( "pthread_mutex_fast\n" );
	}
	else if( params.start == DO_END )
	{
		pthread_mutexattr_settype( &( mutexAttr ), PTHREAD_MUTEX_RECURSIVE );
		printf( "pthread_mutex_recursive\n" );
	}
	printf( "sem_unlock\n" );
	
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
		
		printf( "%f\n", GetMicroDiff( &( postTime ), afterWaitTime ) );
		
		free( afterWaitTime );
	}
	
	return 0;
}