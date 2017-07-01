package at.dotpoint.huntsman.analyser.parser;

import at.dotpoint.huntsman.analyser.script.ScriptReference;
import at.dotpoint.huntsman.analyser.parser.source.SourceParserFactory;
import haxe.io.Path;
import sys.FileSystem;

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
	public function createFromJson( parserJson:Dynamic, configRoot:Path, scripts:Array<ScriptReference> ):INodeParser
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
				parser = new SourceParserFactory().createSourceParser( name, new Path(settings), parserJson.script, scripts );

			default:
				throw "unknown parser type: " + type;
		}

		return parser;
	}

}
