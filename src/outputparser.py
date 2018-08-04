import os
import sys
import json
import select
import argparse

import numpy as np

class Data:
	def __init__( self, size ):
		self.index = 0
		self.data = np.zeros( size )
		
	def add( self, value ):
		self.data[ self.index ] = value
		self.index = self.index + 1
		
	def resetIndex( self ):
		self.index = 0;
	
	def cnt( self ):
		return np.count_nonzero( self.data )
	def max( self ):
		return np.max( self.data )
	def min( self ):
		return np.min( self.data )
	def avg( self ):
		return np.average( self.data )
	def std( self ):
		return np.std( self.data )
		
	def toJSON( self ):
		return {
			'count': self.cnt( ),
			'max': self.max( ),
			'min': self.min( ),
			'avg': self.avg( ),
			'std': self.std( )
			}
	

class ThreadInfo:
	def __init__( self, size ):
		self.starts = Data( size )
		self.ends = Data( size )
		
	def addTimes( self, start, end ):
		self.starts.add( start )
		self.ends.add( end )
		
	def resetIndex( self ):
		self.starts.resetIndex( )
		self.ends.resetIndex( )
		
	def startInfo( self ):
		return self.starts
		
	def endInfo( self ):
		return self.ends
		
	def toJSON( self ):
		return { 
			'start': self.starts.toJSON( ),
			'end': self.starts.toJSON( )
			}

def parseData( inputRawData, dataName, jsonFileName ):
	newData = ThreadInfo( len( inputRawData ) )
	
	for line in inputRawData:
		if line != '':
			numbers = line.split( )
			newData.addTimes( float( numbers[ 0 ] ), float( numbers[ 1 ] ) )
	
	if os.path.exists( jsonFileName ):
		with open( jsonFileName, 'r' ) as f:
			existingData = json.load( f )
	else:
		existingData = {}
	
	existingData[ dataName ] = newData.toJSON( )
	
	with open( jsonFileName, 'w' ) as f:
		json.dump( existingData, f, indent=4, sort_keys=True )
	
		
def main( ):
	parser = argparse.ArgumentParser( description='Process thread data.' )
	parser.add_argument( '--file', help='JSON file to store data' )
	parser.add_argument( '--name', help='Data name' )
	
	args = parser.parse_args( )
	
	if select.select( [ sys.stdin ], [ ], [ ], 0.0 )[ 0 ]:
		parseData( [ x.strip( ) for x in sys.stdin.read( ).split( '\n' ) ], args.name, args.file )
	else:
		print 'DO SOMETHING?'

if __name__ == '__main__':
	sys.exit( main( ) )