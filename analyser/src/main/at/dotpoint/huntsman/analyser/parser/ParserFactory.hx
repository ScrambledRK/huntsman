package at.dotpoint.huntsman.analyser.parser;

import at.dotpoint.huntsman.analyser.parser.source.TokenType;
import haxe.Json;
import sys.io.File;
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
		var json:Dynamic = this.parseSettings( settingsPath );

		var settings:SourceParserSettings = new SourceParserSettings();
			settings.extensions = this.parseExtensions( json );
			settings.tokens = this.parseTokens( json );

		// ------------------------ //

		return new SourceParser( name, settings );
	}

	/**
	 *
	 */
	private function parseSettings( settingsPath:Path ):Dynamic
	{
		var json:Dynamic = null;

		try
		{
		  json = Json.parse( File.getContent( settingsPath.toString() ) );
		}
		catch( exception:Dynamic )
		{
		  throw "json parse settings failed:\n" + exception.toString();
		}

		if( json == null )
		  throw "json parse settings failed: unknown error, json is null";

		return json;
	}

	/**
	 *
	 */
	private function parseExtensions( json:Dynamic ):Array<String>
	{
		var extensions:Array<Dynamic> = cast json.extensions;

		if( extensions == null || extensions.length == 0 )
			throw "must contain non-empty extensions array";

		// ------------- //

		var result:Array<String> = new Array<String>();

		for( ext in extensions )
		  result.push( ext );

		return result;
	}

	/**
	 *
	 */
	private function parseTokens( json:Dynamic ):Array<TokenType>
	{
		var tokens:Array<Dynamic> = cast json.tokens;

		if( tokens == null || tokens.length == 0 )
			throw "must contain non-empty tokens array";

		var keywords:Array<Dynamic> = cast json.keywords;

		// ------------- //

		var result:Array<TokenType> = new Array<TokenType>();

		if( keywords != null && keywords.length > 0 )
		{
			for( key in keywords )
			{
				var name:String = key;
				var expr:EReg = new EReg( "\\b" + key + "\\b", "gm" );

				result.push( new TokenType( name, expr ) );
			}
		}

		for( tok in tokens )
		{
			var name:String = tok.name;
			var expr:EReg = new EReg( tok.expression, "gm" );

			result.push( new TokenType( name, expr ) );
		}

		return result;
	}
}
