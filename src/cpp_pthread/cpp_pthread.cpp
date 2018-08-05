#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include <string.h>

#define NSEC_IN_A_SEC	( 1000000000U )
#define NSEC_IN_A_MSEC	( 1000000U )

#define DO_START		( 0 )
#define DO_END			( 1 )

typedef struct PARAMS_STRUCT
{
	int count;
	int start;
} PARAMS;

static float GetMicroDiff( struct timespec* timeEarlier, struct timespec* timeLater )
{
	unsigned int diffInt = ( ( ( timeLater->tv_sec - timeEarlier->tv_sec ) * NSEC_IN_A_SEC ) 
		+ ( timeLater->tv_nsec - timeEarlier->tv_nsec ) );
		
	return ( float )( diffInt ) / ( float ) ( NSEC_IN_A_MSEC );
}

static void GetTime( struct timespec* time )
{
	clock_gettime( CLOCK_MONOTONIC_COARSE, time );
}

static void* start_thread_func( void *arg )
{	
	struct timespec actualStartTime;
	struct timespec* returnedStartTime;

	GetTime( &( actualStartTime ) );
	
	returnedStartTime = ( struct timespec* ) calloc( 1, sizeof( struct timespec ) );
	memcpy( returnedStartTime, &( actualStartTime ), sizeof( struct timespec ) );
	
	pthread_exit( returnedStartTime );
}

static void* shutdown_thread_func( void *arg )
{	
	struct timespec* endTime;

	endTime = ( struct timespec* ) calloc( 1, sizeof( struct timespec ) );
	
	GetTime( endTime );
	
	pthread_exit( endTime );
}

static PARAMS getParams( int argc, char* const argv[ ] )
{
	int opt;
	PARAMS params;
	
	params.count = 1000;
	params.start = DO_START;
	
	do
	{
		opt = getopt( argc, argv, "c:se" );
		
		switch( opt )
		{
			case( 'c' ):
				params.count = atoi( optarg );
				break;
			case( 's' ):
				params.start = DO_START;
				break;
			case ( 'e' ):
				params.start = DO_END;
				break;
			case( -1 ):
				break;
			default:
				fprintf( stderr, "Unknown flag %c\n", opt );
				fprintf( stderr, "Usage: %s [-c count] [-s] [-e]\n", argv[ 0 ] );
				exit( -1 );
				break;
		}
	} while( opt != -1 );
	
	return params;
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	
	PARAMS params = getParams( argc, argv );
	
	printf( "C++\n" );
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