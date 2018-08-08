import os
import re
import sys
import json
import select
import argparse
import subprocess

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
		
	def testName( self ):
		return '{}__{}'.format( self.lang, self.lib )
		
	def uniqueName( self ):
		return '{}__{}__{}__{}'.format( self.name, getCPUName( ), self.lang, self.lib )
	
	def nonZeroData( self ):
		return self.data[ np.nonzero( self.data ) ]
		
	def graphFileName( self ):
		fileName = self.uniqueName( )
		fileName = fileName.replace( '+', 'P' )
		fileName = fileName.replace( ':', '' )
		fileName = fileName.replace( ' ', '_' )
	
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
		
	def getJSONData( self ):
		return {
			'uniqueName': self.uniqueName( ),
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
		title = '{}\nCount={} Max={:.3f} Min={:.3f} Avg={:.3f} StdDev={:.3f}'.format( self.uniqueName( ), 
			self.cnt( ), self.max( ), self.min( ), self.avg( ), self.std( ) )
	
		fig, ax = plt.subplots( nrows=1, ncols=1 )
		fig.suptitle( title )
		ax.set_ylim( 0, 1 )
		ax.set_ylabel( 'Time (ms)' )
		ax.set_xlabel( 'Test Number' )
		ax.plot( self.nonZeroData( ) )
		fig.savefig( self.graphFileName( ) )
		plt.close( fig )	

def getCPUName( ):
	all_info = subprocess.check_output( 'cat /proc/cpuinfo', shell = True ).strip( )
	for line in all_info.split( '\n' ):
		if 'model name' in line:
			rawName = re.sub( '.*model name.*:', '', line, 1 )
			rawName = rawName.replace( '@', '' )
			rawName = rawName.replace( '(R)', '' )
			rawName = rawName.replace( '(TM)', '' )
                        rawName = rawName.replace( '(', '' )
                        rawName = rawName.replace( ')', '' )
			return ' '.join( rawName.split( ) )
		
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
	
	procName = getCPUName( )
	
	if not newData.name in existingData:
		existingData[ newData.name ] = {}
		
	if not procName in existingData[ newData.name ]:
		existingData[ newData.name ][ procName ] = {}
	
	existingData[ newData.name ][ procName ][ newData.testName( ) ] = newData.getJSONData( )
	
	with open( jsonFileName, 'w' ) as f:
		json.dump( existingData, f, indent=4, sort_keys=True )
	
def createMarkdown( jsonFileName, markdownFileName, markdownHeaderFileName ):
	header = open( markdownHeaderFileName, 'r' ).read( )

	with open( jsonFileName, 'r' ) as f:
		jsonData = json.load( f )
			
	with open( markdownFileName, 'w' ) as f:
		f.write( header )
		f.write( '\n' )
		f.write( '# Results\n' )
		for testName in sorted( jsonData ):
			f.write( '\n' )
			f.write( '## Test: {}\n'.format( testName ) )
			headerNames = '|Description|'
			headerBar = '|-----------|'
			for proc in sorted( jsonData[ testName ] ):
				headerNames += '{}|'.format( proc )
				headerBar += '{}|'.format( '-' * len( proc ) )
			f.write( '\n' )
			f.write( '{}\n'.format( headerNames ) )
			f.write( '{}\n'.format( headerBar ) )
			for proc in sorted( jsonData[ testName ] ):
				for testRunName in sorted( jsonData[ testName ][ proc ] ):
					data = jsonData[ testName ][ proc ][ testRunName ]
					description = '{} - {}'.format( data[ 'language' ], data[ 'library' ] )
					graph = '![{}]({})'.format( data[ 'uniqueName' ], data[ 'graph' ] )
					
					f.write( '|{}|{}|\n'.format( description, graph ) )
		#	for testName in sorted( jsonData[ proc ] ):
		#		f.write( '### Test: {}\n'.format( testName ) )
		#		f.write( '|Description|Graph|\n' )
		#		f.write( '|-----------|-----|\n' )
		#		for testRunName in sorted( jsonData[ proc ][ testName ] ):
		#			data = jsonData[ proc ][ testName ][ testRunName ]
		#			
		#			description = '{} - {}'.format( data[ 'language' ], data[ 'library' ] )
		#			graph = '![{}]({})'.format( data[ 'uniqueName' ], data[ 'graph' ] )
		#			
		#			f.write( '|{}|{}|\n'.format( description, graph ) )

				
def main( ):
	parser = argparse.ArgumentParser( description='Process thread data.' )
	parser.add_argument( '--name', help='Data name' )
	parser.add_argument( '--jsonfile', help='JSON file to store data' )
	parser.add_argument( '--markdownheader', help='Markdown file header' )
	parser.add_argument( '--markdownfile', help='Markdown file to be generated' )
	parser.add_argument( '--rootPath', help='Root folder' )
	parser.add_argument( '--graphPath', help='Path where graphs should be stored', default=os.path.dirname( sys.argv[ 0 ] ) )
	
	args = parser.parse_args( )
	
	if select.select( [ sys.stdin ], [ ], [ ], 0.0 )[ 0 ]:
		parseData( [ x.strip( ) for x in sys.stdin.read( ).split( '\n' ) ], args.name, args.jsonfile,
			os.path.relpath( args.graphPath, args.rootPath ) )
	else:
		createMarkdown( args.jsonfile, args.markdownfile, args.markdownheader )

if __name__ == '__main__':
	sys.exit( main( ) )

