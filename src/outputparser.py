import os
import sys
import json
import select
import argparse

import matplotlib
matplotlib.use('Agg')

import numpy as np
import matplotlib.pyplot as plt

class Data:
	def __init__( self, lang, lib, name, size, graphPath ):
		self.index = 0
		self.data = np.zeros( size )
		self.lang = lang
		self.lib = lib
		self.name = name
		self.graphPath = graphPath
		
	def add( self, value ):
		self.data[ self.index ] = value
		self.index = self.index + 1
		
	def resetIndex( self ):
		self.index = 0;
		
	def uniqueName( self ):
		return '{}__{}__{}'.format( self.lang, self.lib, self.name )
	
	def nonZeroData( self ):
		return self.data[ np.nonzero( self.data ) ]
		
	def graphFileName( self ):
		fileName = self.uniqueName( )
		fileName = fileName.replace( '+', 'P' )
		fileName = fileName.replace( ':', '' )
	
		return os.path.join( self.graphPath, fileName + '.png' )
	
	def cnt( self ):
		return np.count_nonzero( self.data )
	def max( self ):
		return np.max( self.nonZeroData( ) )
	def min( self ):
		return np.min( self.nonZeroData( ) )
	def avg( self ):
		return np.average( self.nonZeroData( ) )
	def std( self ):
		return np.std( self.nonZeroData( ) )
		
	def toJSON( self ):	
		return {
			'language': self.lang,
			'library': self.lib,
			'name': self.name,
			'count': self.cnt( ),
			'max': self.max( ),
			'min': self.min( ),
			'avg': self.avg( ),
			'std': self.std( ),
			'graph': self.graphFileName( )
			}
		
	def graphData( self ):
		fig, ax = plt.subplots( nrows=1, ncols=1 )
		fig.suptitle( self.uniqueName( ) )
		ax.set_ylim( 0, 1 )
		ax.plot( self.nonZeroData( ) )
		fig.savefig( self.graphFileName( ) )
		plt.close( fig )	

def parseData( inputRawData, dataName, jsonFileName, graphPath ):
	newData = Data( inputRawData[ 0 ], inputRawData[ 1 ], inputRawData[ 2 ], len( inputRawData ) - 3, graphPath )
	
	for line in inputRawData[ 3 : ]:
		if line != '':
			newData.add( float( line ) )
	newData.graphData( )
	
	if os.path.exists( jsonFileName ):
		with open( jsonFileName, 'r' ) as f:
			existingData = json.load( f )
	else:
		existingData = {}
	
	existingData[ dataName ] = newData.toJSON( )
	
	with open( jsonFileName, 'w' ) as f:
		json.dump( existingData, f, indent=4, sort_keys=True )
	
def createMarkdown( jsonFileName, markdownFileName, markdownHeaderFileName, graphPath ):
	header = open( markdownHeaderFileName, 'r' ).read( )

	with open( jsonFileName, 'r' ) as f:
		jsonData = json.load( f )
			
	with open( markdownFileName, 'w' ) as f:
		f.write( header )
		f.write( '\n' )
		f.write( '# Data' )
		f.write( '\n' )
		f.write( '|Language|Library|Type|Count|Max|Min|Average|Std Dev|Graph|\n' )
		f.write( '|--------|-------|----|-----|---|---|-------|-------|-----|\n' )
		for key in sorted( jsonData ):
			data = jsonData[ key ]
			f.write( '|{}|{}|{}|{}|{:.3f}|{:.3f}|{:.3f}|{:.3f}|{}|\n'.format(
				data[ 'language' ], data[ 'library' ], data[ 'name' ],
				data[ 'count' ], data[ 'max' ], data[ 'min' ], data[ 'avg' ], data[ 'std' ], 
				'[Graph]({})'.format( os.path.relpath( data[ 'graph' ], os.path.dirname( markdownFileName ) ) ) ) )

				
def main( ):
	parser = argparse.ArgumentParser( description='Process thread data.' )
	parser.add_argument( '--name', help='Data name' )
	parser.add_argument( '--jsonfile', help='JSON file to store data' )
	parser.add_argument( '--markdownheader', help='Markdown file header' )
	parser.add_argument( '--markdownfile', help='Markdown file to be generated' )
	parser.add_argument( '--graphPath', help='Path where graphs should be stored', default=os.path.dirname( sys.argv[ 0 ] ) )
	
	args = parser.parse_args( )
	
	if select.select( [ sys.stdin ], [ ], [ ], 0.0 )[ 0 ]:
		parseData( [ x.strip( ) for x in sys.stdin.read( ).split( '\n' ) ], args.name, args.jsonfile, args.graphPath )
	else:
		createMarkdown( args.jsonfile, args.markdownfile, args.markdownheader, args.graphPath )

if __name__ == '__main__':
	sys.exit( main( ) )