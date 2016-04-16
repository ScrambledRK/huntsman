package at.dotpoint.huntsman.analyser.parser;

import at.dotpoint.huntsman.analyser.parser.source.SourceParserSettings;
import haxe.io.Path;
import sys.FileSystem;
import at.dotpoint.huntsman.analyser.parser.source.SourceParser;

/**
 * 16.04.2016
 * @author RK
 */
class ParserFactory
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( )
	{

	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function createFromJson( parserJson:Dynamic, configRoot:Path ):INodeParser
	{
		var name:String = StringTools.trim( parserJson.name );

		if( name == null || name.length == 0 )
			throw "must contain non-empty parser name";

		// --------- //

		var type:String = StringTools.trim( parserJson.type );

		if( type == null || type.length == 0 )
			throw "must contain non-empty parser type";

		// --------- //

		var settings:String = Path.join( [ configRoot.toString(), StringTools.trim( parserJson.settings ) ] );

		if( settings == null || settings.length == 0 )
		  throw "must contain non-empty parser settings path";

		if( !FileSystem.exists( settings ) )
		  throw "parser settings path '" + settings + "' does not exist";

		if( FileSystem.isDirectory( settings ) )
		  throw "parser settings path '" + settings + "' is not a file";

		// --------- //

		var parser:INodeParser = null;

		switch( type )
		{
			case "source":
				parser = this.createSourceParser( name, new Path(settings) );

			default:
				throw "unknown parser type: " + type;
		}

		return parser;
	}

	/**
	 *
	 */
	private function createSourceParser( name:String, settingsPath:Path ):INodeParser
	{
		var settings:SourceParserSettings = new SourceParserSettings();

		return new SourceParser( name, settings );
	}
}
