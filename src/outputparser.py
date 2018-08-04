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
		return np.max( self.data[ np.nonzero( self.data ) ] )
	def min( self ):
		return np.min( self.data[ np.nonzero( self.data ) ] )
	def avg( self ):
		return np.average( self.data[ np.nonzero( self.data ) ] )
	def std( self ):
		return np.std( self.data[ np.nonzero( self.data ) ] )
		
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
			'end': self.ends.toJSON( )
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

def writeThreadInfo( jsonData, type, f ):
	f.write( '\n' )
	f.write( '|Name|Count|Max|Min|Average|Std Dev|\n' )
	f.write( '|----|-----|---|---|-------|-------|\n' )
	for key in jsonData:
		data = jsonData[ key ][ type ]
		f.write( '|{}|{}|{:.3f}|{:.3f}|{:.3f}|{:.3f}|\n'.format( key, data[ 'count' ], data[ 'max' ], data[ 'min' ], data[ 'avg' ], data[ 'std' ] ) )
		
def createMarkdown( jsonFileName, markdownFileName, markdownHeaderFileName ):
	header = open( markdownHeaderFileName, 'r' ).read( )

	with open( jsonFileName, 'r' ) as f:
		jsonData = json.load( f )
			
	with open( markdownFileName, 'w' ) as f:
		f.write( header )
		f.write( '\n' )
		f.write( '# Thread Start/Stop\n' )
		f.write( '## Thread Start\n' )
		f.write( 'Each measurement is the time (in ms) between the call to start the task and the task actually running\n' )
		writeThreadInfo( jsonData, 'start', f )
		f.write( '\n' )
		f.write( '## Thread Shutdown\n' )
		f.write( 'Each measurement is the time (in ms) between task exiting and the main receiving notification that the task has exited\n' )
		writeThreadInfo( jsonData, 'end', f )
		
def main( ):
	parser = argparse.ArgumentParser( description='Process thread data.' )
	parser.add_argument( '--name', help='Data name' )
	parser.add_argument( '--jsonfile', help='JSON file to store data' )
	parser.add_argument( '--markdownheader', help='Markdown file header' )
	parser.add_argument( '--markdownfile', help='Markdown file to be generated' )
	
	args = parser.parse_args( )
	
	if select.select( [ sys.stdin ], [ ], [ ], 0.0 )[ 0 ]:
		parseData( [ x.strip( ) for x in sys.stdin.read( ).split( '\n' ) ], args.name, args.jsonfile )
	else:
		createMarkdown( args.jsonfile, args.markdownfile, args.markdownheader )

if __name__ == '__main__':
	sys.exit( main( ) )