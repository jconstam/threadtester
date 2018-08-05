#include <iostream>
#include <cstdlib>
#include <cstring>
#include <ctime>

#include <unistd.h>
#include <pthread.h>

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
	
	usleep( 10 );
	
	returnedStartTime = new struct timespec( );
	memcpy( returnedStartTime, &( actualStartTime ), sizeof( struct timespec ) );
	
	pthread_exit( returnedStartTime );
}

static void* shutdown_thread_func( void *arg )
{	
	struct timespec* endTime;

	endTime = new struct timespec( );
	
	usleep( 10 );
	
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
				std::cerr << "Unknown flag " << opt << std::endl;
				std::cerr << "Usage: " << argv[ 0 ] << " [-c count] [-s] [-e]" << std::endl;
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