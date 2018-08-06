#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cstring>
#include <string>
#include <thread>
#include <future>

#include <unistd.h>

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

static struct timespec start_thread_func( )
{	
	struct timespec startTime;

	GetTime( &( startTime ) );
	
	usleep( 1000 );
	
	return startTime;
}

static struct timespec shutdown_thread_func( )
{	
	struct timespec endTime;
	
	usleep( 1000 );
	
	GetTime( &( endTime ) );
	
	return endTime;
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
	std::cout << "std::async" << std::endl;
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
			
			GetTime( &( preStartTime ) );
			auto future = std::async( start_thread_func );
			startTime = future.get( );
			
			std::cout << GetMicroDiff( &( preStartTime ), &( startTime ) ) << std::endl;
		}
		else if( params.start == DO_END )
		{
			struct timespec postEndTime;
			struct timespec endTime;
			
			auto future = std::async( shutdown_thread_func );
			endTime = future.get( );
			
			GetTime( &( postEndTime ) );
			
			std::cout << GetMicroDiff( &( endTime ), &( postEndTime ) ) << std::endl;
		}
	}
	
	return 0;
}