import os
import sys
import json
import argparse

import jinja2

import matplotlib
matplotlib.use('Agg')

import numpy as np
import matplotlib.pyplot as plt
	
def graphData( args ):
	with open( args.jsonfile, 'r' ) as f:
		jsonData = json.load( f, encoding='utf-8' )
	with open( args.lookupjsonFile, 'r' ) as f:
		lookupData = json.load( f, encoding='utf-8' )
	
	procs = lookupData[ 'CPUs' ]
	colours = [ 'r', 'y', 'b', 'g' ]
	
	results = {}
	for test in jsonData:
		title = lookupData[ 'Tests' ][ test ][ 'name' ]
	
		avgs = {}
		errors = {}
		labels = {}
		for proc in procs:
			avgs[ proc ] = []
			errors[ proc ] = []
			labels[ proc ] = []
		axisLabels = []
			
		count = 0
		textLines = {}
		for testRun in jsonData[ test ]:
			currChar = chr( ord( 'A' ) + count )
			axisLabels.append( currChar )
			count = count + 1
			for proc in jsonData[ test ][ testRun ]:
				data = jsonData[ test ][ testRun ][ proc ]
			
				avgs[ proc ].append( data[ 'avg' ] )
				errors[ proc ].append( data[ 'std' ] )
				label = '{} - {}'.format( data[ 'language' ], data[ 'library' ] )
				labels[ proc ].append( label )
				if not currChar in textLines:
					textLines[ currChar ] = '{} = {}'.format( currChar, label )
		
		text = '\n'.join( [ textLines[ letter ] for letter in sorted( textLines ) ] )

		N = len( avgs.itervalues().next() )
		ind = np.arange( N )
		width = float( 1 ) / float( len( procs ) ) - 0.1

		fig, ax = plt.subplots( )
		fig.suptitle( title )
		ax.set_ylabel( 'Time (ms)' )
		
		count = 0
		graphs = []
		for proc in procs:
			graphs.append( ax.bar( ind + ( count * width ), avgs[ proc ], width, color=colours[count], yerr=errors[ proc ] ) )
			count = count + 1
		ax.set_xticks( ind + width )
		ax.set_xticklabels( axisLabels )
		box = ax.get_position()
		ax.set_position([box.x0, box.y0 + box.height * 0.2, box.width, box.height * 0.8])
		ax.legend( graphs, [ lookupData[ 'CPUs' ][ proc ] for proc in procs ], loc='upper left', bbox_to_anchor=(0.5, -0.05) )
		ax.text( 0.13, 0.2, text, fontsize=10, transform=fig.transFigure, verticalalignment='top', 
			bbox=dict( boxstyle='square', facecolor='white', alpha=1 ) )
		
		path = os.path.join( os.path.relpath( args.graphPath, os.path.dirname( args.htmlFile ) ), test + '.png' )
		results[ test ] = path
		
		fig.savefig( os.path.join( os.path.dirname( args.htmlFile ), path ) )
		plt.close( fig )

	return results
		
def main( ):
	parser = argparse.ArgumentParser( description='Process thread data.' )
	parser.add_argument( '--jsonfile', required=True, help='JSON file to store data' )
	parser.add_argument( '--lookupjsonFile', required=True, help='JSON file to lookup strings' )
	parser.add_argument( '--htmlFile', required=True, help='HTML file to be generated' )
	parser.add_argument( '--htmlTemplate', required=True, help='HTML template' )
	parser.add_argument( '--graphPath', required=True, help='Path where graphs should be stored', default=os.path.dirname( sys.argv[ 0 ] ) )
	
	args = parser.parse_args( )
		
	graphs = graphData( args )
	
	with open( args.jsonfile, 'r' ) as f:
		jsonData = json.load( f, encoding='utf-8' )
	with open( args.lookupjsonFile, 'r' ) as f:
		lookupData = json.load( f, encoding='utf-8' )
	with open( args.htmlTemplate, 'r' ) as f:
		templateData = f.read( )
	
	t = jinja2.Template( templateData )
	
	with open( args.htmlFile, 'w' ) as f:
		f.write( t.render( results = jsonData, lookup = lookupData, graphs = graphs ) )

if __name__ == '__main__':
	sys.exit( main( ) )

