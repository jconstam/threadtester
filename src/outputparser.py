import sys
import fileinput

import numpy as np

class ThreadInfo:
	def __init__( self, size ):
		self.index = 0
		self.starts = np.zeros( size )
		self.ends = np.zeros( size )
		
	def addTimes( self, start, end ):
		self.starts[ self.index ] = start
		self.ends[ self.index ] = end
		self.index = self.index + 1
		
	def resetIndex( self ):
		self.index = 0
		
	def printInfo( self, array ):
		print '\tCount:  {}'.format( np.count_nonzero( array ) )
		print '\tMax:    {:.3f}'.format( np.max( array ) )
		print '\tMin:    {:.3f}'.format( np.min( array ) )
		print '\tAvg:    {:.3f}'.format( np.average( array ) )
		print '\tStdDev: {:.3f}'.format( np.std( array ) )
		
	def printStartInfo( self ):
		self.printInfo( self.starts )
		
	def printEndInfo( self ):
		self.printInfo( self.ends )

def main( ):
	inputRawData = [ x.strip( ) for x in fileinput.input( ) ]

	data = ThreadInfo( len( inputRawData ) )
	
	for line in inputRawData:
		numbers = line.split( )
		data.addTimes( float( numbers[ 0 ] ), float( numbers[ 1 ] ) )
		
	print 'Thread Startup:'
	data.printStartInfo( )
	print 'Thread Shutdown:'
	data.printEndInfo( )

if __name__ == '__main__':
	sys.exit( main( ) )