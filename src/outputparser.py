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

import jinja2

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
		title = 'Count={} Max={:.3f} Min={:.3f} Avg={:.3f} StdDev={:.3f}'.format(  
			self.cnt( ), self.max( ), self.min( ), self.avg( ), self.std( ) )
	
		fig, ax = plt.subplots( nrows=1, ncols=1 )
		fig.suptitle( title )
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
		
	if not newData.testName( ) in existingData[ newData.name ]:
		existingData[ newData.name ][ newData.testName( ) ] = {}
	
	existingData[ newData.name ][ newData.testName( ) ][ procName ] = newData.getJSONData( )
	
	with open( jsonFileName, 'w' ) as f:
		json.dump( existingData, f, indent=4, sort_keys=True )

def main( ):
	parser = argparse.ArgumentParser( description='Process thread data.' )
	parser.add_argument( '--name', required=True, help='Data name' )
	parser.add_argument( '--jsonfile', required=True, help='JSON file to store data' )
	parser.add_argument( '--rootPath', required=True, help='Root folder' )
	parser.add_argument( '--graphPath', required=True, help='Path where graphs should be stored', default=os.path.dirname( sys.argv[ 0 ] ) )
	parser.add_argument( '--lookupjsonFile', required=True, help='JSON file to lookup strings' )
	
	args = parser.parse_args( )
	
	parseData( [ x.strip( ) for x in sys.stdin.read( ).split( '\n' ) ], args.name, args.jsonfile,
		os.path.relpath( args.graphPath, args.rootPath ) )

if __name__ == '__main__':
	sys.exit( main( ) )

