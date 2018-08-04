#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include <string.h>

#define NSEC_IN_A_SEC	( 1000000000U )
#define NSEC_IN_A_MSEC	( 1000000U )

typedef struct THREAD_INFO_STRUCT
{
	struct timespec preStart;
	struct timespec start;
	struct timespec end;
	struct timespec postEnd;
} THREAD_INFO;

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

static void PrintTimeDiff( const char* name, struct timespec* timeEarlier, struct timespec* timeLater )
{
	printf( "%-10s %f\n", name, GetMicroDiff( timeEarlier, timeLater ) );
}

void* thread_func( void *arg )
{
	THREAD_INFO* threadInfo = ( THREAD_INFO* ) arg;
	
	GetTime( &( threadInfo->start ) );
	
	usleep( 10 );
	
	GetTime( &( threadInfo->end ) );
	
	pthread_exit( NULL );
}

int main( int argc, const char* argv[ ] )
{
	const int count = 100;
	
	int i;
	pthread_t thread;
	THREAD_INFO* threadInfo = calloc( count, sizeof( THREAD_INFO ) );
	
	for( i = 0; i < count; i++ )
	{
		memset( &( thread ), 0, sizeof( pthread_t ) );
		
		GetTime( &( threadInfo[ i ].preStart ) );
		
		pthread_create( &( thread ), NULL, thread_func, &( threadInfo[ i ] ) );
		
		pthread_join( thread, NULL );
		
		GetTime( &( threadInfo[ i ].postEnd ) );
		
		printf( "%f %f\n", GetMicroDiff( &( threadInfo[ i ].preStart ), &( threadInfo[ i ].start ) ),
			GetMicroDiff( &( threadInfo[ i ].end ), &( threadInfo[ i ].postEnd ) ) );
	}
	
	free( threadInfo );
	
	return 0;
}