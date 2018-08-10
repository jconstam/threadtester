import sys
import time
import argparse
import threading

class testThread( threading.Thread ):
	def __init__( self, isStart ):
		threading.Thread.__init__( self )
		self.isStart = isStart
		
	def run( self ):
		self.startTime = time.clock_gettime( time.CLOCK_MONOTONIC_RAW )
		time.sleep( 0.001 )
		self.endTime = time.clock_gettime( time.CLOCK_MONOTONIC_RAW )
	
	def join( self ):
		threading.Thread.join( self )
		if self.isStart:
			return self.startTime
		else:
			return self.endTime

def main( ):
	parser = argparse.ArgumentParser( description='Process thread data.' )
	parser.add_argument( '-c', type=int, default=10000, help='Count' )
	parser.add_argument( '-s', action="store_true", help='Start' )
	parser.add_argument( '-e', action="store_true", help='End' )
	
	args = parser.parse_args( )
	
	print( 'python3' )
	print( 'thread' )
	if args.s:
		print( 'thread_start' )
	elif args.e:
		print( 'thread_shutdown' )
	
	for i in range( args.c ):
		thread = testThread( args.s )
		preStartTime = time.clock_gettime( time.CLOCK_MONOTONIC_RAW )
		thread.start( )
		threadTime = thread.join( )
		postEndTime = time.clock_gettime( time.CLOCK_MONOTONIC_RAW )
		if args.s:
			print( ( threadTime - preStartTime ) * 1000 )
		elif args.e:
			print( ( postEndTime - threadTime ) * 1000 )
		

if __name__ == '__main__':
	sys.exit( main( ) )

