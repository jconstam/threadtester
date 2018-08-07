#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "common_c_cpp.h"

#define NSEC_IN_A_SEC	( 1000000000U )
#define NSEC_IN_A_MSEC	( 1000000U )

float GetMicroDiff( struct timespec* timeEarlier, struct timespec* timeLater )
{
	unsigned int diffInt = ( ( ( timeLater->tv_sec - timeEarlier->tv_sec ) * NSEC_IN_A_SEC ) 
		+ ( timeLater->tv_nsec - timeEarlier->tv_nsec ) );
		
	return ( float )( diffInt ) / ( float ) ( NSEC_IN_A_MSEC );
}

void GetTime( struct timespec* time )
{
	clock_gettime( CLOCK_MONOTONIC, time );
}

PARAMS getParams( int argc, char* const argv[ ] )
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