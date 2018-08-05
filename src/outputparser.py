import os
import sys
import json
import select
import argparse

import numpy as np

class Data:
	def __init__( self, lang, lib, name, size ):
		self.index = 0
		self.data = np.zeros( size )
		self.lang = lang
		self.lib = lib
		self.name = name
		
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
			'language': self.lang,
			'library': self.lib,
			'name': self.name,
			'count': self.cnt( ),
			'max': self.max( ),
			'min': self.min( ),
			'avg': self.avg( ),
			'std': self.std( )
			}

def parseData( inputRawData, dataName, jsonFileName ):
	newData = Data( inputRawData[ 0 ], inputRawData[ 1 ], inputRawData[ 2 ], len( inputRawData ) - 3 )
	
	for line in inputRawData[ 3 : ]:
		if line != '':
			newData.add( float( line ) )
	
	if os.path.exists( jsonFileName ):
		with open( jsonFileName, 'r' ) as f:
			existingData = json.load( f )
	else:
		existingData = {}
	
	existingData[ dataName ] = newData.toJSON( )
	
	with open( jsonFileName, 'w' ) as f:
		json.dump( existingData, f, indent=4, sort_keys=True )
	
def createMarkdown( jsonFileName, markdownFileName, markdownHeaderFileName ):
	header = open( markdownHeaderFileName, 'r' ).read( )

	with open( jsonFileName, 'r' ) as f:
		jsonData = json.load( f )
			
	with open( markdownFileName, 'w' ) as f:
		f.write( header )
		f.write( '\n' )
		f.write( '# Data' )
		f.write( '\n' )
		f.write( '|Language|Library|Type|Count|Max|Min|Average|Std Dev|\n' )
		f.write( '|--------|-------|----|-----|---|---|-------|-------|\n' )
		for key in sorted( jsonData ):
			data = jsonData[ key ]
			f.write( '|{}|{}|{}|{}|{:.3f}|{:.3f}|{:.3f}|{:.3f}|\n'.format(
				data[ 'language' ], data[ 'library' ], data[ 'name' ],
				data[ 'count' ], data[ 'max' ], data[ 'min' ], data[ 'avg' ], data[ 'std' ] ) )
		
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