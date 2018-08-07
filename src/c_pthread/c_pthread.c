#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>

#include "common_c_cpp.h"

static void* start_thread_func( void *arg )
{	
	struct timespec actualStartTime;
	struct timespec* returnedStartTime;

	GetTime( &( actualStartTime ) );
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	returnedStartTime = calloc( 1, sizeof( struct timespec ) );
	memcpy( returnedStartTime, &( actualStartTime ), sizeof( struct timespec ) );
	
	pthread_exit( returnedStartTime );
}

static void* shutdown_thread_func( void *arg )
{	
	struct timespec* endTime;

	endTime = calloc( 1, sizeof( struct timespec ) );
	
	usleep( THREAD_MIN_ALIVE_TIME_US );
	
	GetTime( endTime );
	
	pthread_exit( endTime );
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	
	PARAMS params = getParams( argc, argv );
	
	printf( "C\n" );
	printf( "pthread\n" );
	if( params.start == DO_START )
	{
		printf( "thread_start\n" );	
	}
	else if( params.start == DO_END )
	{
		printf( "thread_shutdown\n" );	
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
			
			printf( "%f\n", GetMicroDiff( &( preStartTime ), startTime ) );
			
			free( startTime );
		}
		else if( params.start == DO_END )
		{
			struct timespec postEndTime;
			struct timespec* endTime;
			
			pthread_create( &( thread ), NULL, shutdown_thread_func, NULL );
		
			pthread_join( thread, ( void** ) &( endTime ) );
			
			GetTime( &( postEndTime ) );
			
			printf( "%f\n", GetMicroDiff( endTime, &( postEndTime ) ) );
			
			free( endTime );
		}
	}
	
	return 0;
}