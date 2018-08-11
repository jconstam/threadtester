import sys
import json
import argparse

import jinja2

def main( ):
	parser = argparse.ArgumentParser( description='Process thread data.' )
	parser.add_argument( '--jsonfile', required=True, help='JSON file to store data' )
	parser.add_argument( '--lookupjsonFile', required=True, help='JSON file to lookup strings' )
	parser.add_argument( '--htmlFile', required=True, help='HTML file to be generated' )
	parser.add_argument( '--htmlTemplate', required=True, help='HTML template' )
	
	args = parser.parse_args( )
	
	with open( args.jsonfile, 'r' ) as f:
		jsonData = json.load( f, encoding='utf-8' )
	with open( args.lookupjsonFile, 'r' ) as f:
		lookupData = json.load( f, encoding='utf-8' )
	with open( args.htmlTemplate, 'r' ) as f:
		templateData = f.read( )
	
	t = jinja2.Template( templateData )
	
	with open( args.htmlFile, 'w' ) as f:
		f.write( t.render( results = jsonData, lookup = lookupData ) )

if __name__ == '__main__':
	sys.exit( main( ) )

