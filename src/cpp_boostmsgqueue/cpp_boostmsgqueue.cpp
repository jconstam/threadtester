#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cstring>
#include <string>

#define BOOST_THREAD_PROVIDES_FUTURE
#include <boost/thread.hpp>
#include <boost/thread/future.hpp>
#include <boost/interprocess/ipc/message_queue.hpp>

#include <unistd.h>

#include "common_c_cpp.h"

#define QUEUE_NAME	"test_queue"

using namespace boost::interprocess;

typedef struct QUEUE_DATA_STRUCT
{
	message_queue* queue;
	int size;
	int* sendMessage;
	int* recvMessage;
} QUEUE_DATA;

static QUEUE_DATA queueData;

static void message_func( boost::promise<struct timespec> &promise )
{	
	std::size_t recvSize;
	unsigned int priority;
	struct timespec endTime;
	
	queueData.queue->receive( queueData.recvMessage, queueData.size * sizeof( int ), recvSize, priority );
	GetTime( &( endTime ) );
	
	promise.set_value( endTime );
}

int main( int argc, char* const argv[ ] )
{	
	int i;
	queueData.size = 0;
	
	PARAMS params = getParams( argc, argv );
	
	std::cout << "C++" << std::endl;
	if( params.start == DO_START )
	{	
		std::cout << "boost::message_queue_small" << std::endl;
		queueData.size = SMALL_MSG_SIZE;
	}
	else if( params.start == DO_END )
	{
		std::cout << "boost::message_queue_large" << std::endl;
		queueData.size = LARGE_MSG_SIZE;
	}
	std::cout << "msg_sendrcv" << std::endl;
	
	queueData.sendMessage = new int[ queueData.size ];
	queueData.recvMessage = new int[ queueData.size ];
	
	message_queue::remove( QUEUE_NAME );
	queueData.queue = new message_queue( create_only, QUEUE_NAME, 1, queueData.size * sizeof( int ) );
	
	for( i = 0; i < params.count; i++ )
	{
		struct timespec sendTime;
		struct timespec recvTime;
			
		boost::promise<struct timespec> p;
		boost::future<struct timespec> f = p.get_future();
		
		boost::thread t{ message_func, std::ref( p ) };
	
		usleep( THREAD_MIN_ALIVE_TIME_US );
		
		GetTime( &( sendTime ) );
		queueData.queue->send( queueData.sendMessage, queueData.size * sizeof( int ), 0 );
		
		t.join( );
		
		recvTime = f.get( );
			
		std::cout << GetMicroDiff( &( sendTime ), &( recvTime ) ) << std::endl;
	}
	
	message_queue::remove( QUEUE_NAME );
	
	delete[] queueData.sendMessage;
	delete[] queueData.recvMessage;
	
	return 0;
}