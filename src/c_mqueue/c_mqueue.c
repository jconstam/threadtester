#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <fcntl.h>
#include <mqueue.h>

#include "common_c_cpp.h"

static int* sendMessage;
static int* recvMessage;

typedef struct MSGQ_DATA_STRUCT
{
	mqd_t queue;
	int size;
} MSGQ_DATA;

static void* message_thread_func( void* arg )
{	
	struct timespec actualReceiveTime;
	struct timespec* returnedActualReceiveTime;
	
	MSGQ_DATA* queueData = ( MSGQ_DATA* ) arg;

	mq_receive( queueData->queue, ( char* ) recvMessage, queueData->size, NULL );
	GetTime( &( actualReceiveTime ) );
	
	returnedActualReceiveTime = calloc( 1, sizeof( struct timespec ) );
	memcpy( returnedActualReceiveTime, &( actualReceiveTime ), sizeof( struct timespec ) );
	
	pthread_exit( returnedActualReceiveTime );
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	pthread_t thread;
	MSGQ_DATA queueData;
	
	const int SMALL_SIZE = 100;
	const int LARGE_SIZE = 1000000;
	
	PARAMS params = getParams( argc, argv );
	
	queueData.queue = mq_open( "/test_queue", O_RDWR );
	
	printf( "C\n" );
	if( params.start == DO_START )
	{
		printf( "mqueue_small\n" );
		queueData.size = SMALL_SIZE;
	}
	else if( params.start == DO_END )
	{
		printf( "mqueue_large\n" );
		queueData.size = LARGE_SIZE;
	}
	printf( "msg_sendrcv\n" );
	
	sendMessage = calloc( queueData.size, sizeof( int ) );
	recvMessage = calloc( queueData.size, sizeof( int ) );
	for( i = 0; i < params.count; i++ )
	{
		memset( &( thread ), 0, sizeof( pthread_t ) );
		
		struct timespec sendTime;
		struct timespec* afterWaitTime;
		
		pthread_create( &( thread ), NULL, message_thread_func, &( queueData ) );
		
		usleep( THREAD_MIN_ALIVE_TIME_US );
		
		GetTime( &( sendTime ) );
		mq_send( queueData.queue, ( char* ) sendMessage, queueData.size, 0 );
	
		pthread_join( thread, ( void** ) &( afterWaitTime ) );
		
		printf( "%f\n", GetMicroDiff( &( sendTime ), afterWaitTime ) );
		
		free( afterWaitTime );
	}
	free( sendMessage );
	free( recvMessage );
	
	return 0;
}