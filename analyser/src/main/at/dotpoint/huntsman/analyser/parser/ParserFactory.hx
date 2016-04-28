package at.dotpoint.huntsman.analyser.parser;

import at.dotpoint.huntsman.analyser.parser.source.pattern.PatternCardinality;
import at.dotpoint.huntsman.analyser.parser.source.pattern.PatternReference;
import at.dotpoint.huntsman.analyser.parser.source.token.TokenType;
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
			settings.patterns = this.parsePatterns( json, settings.tokens );

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

	/**
	 *
	 */
	private function parsePatterns( json:Dynamic, tokens:Array<TokenType> ):Array<PatternReference>
	{
		var patterns:Array<Dynamic> = cast json.patterns;

		if( patterns == null || patterns.length == 0 )
			throw "must contain non-empty patterns array";

		// -------------- //

		var result:Array<PatternReference> = new Array<PatternReference>();

		for( pattern in patterns )
			result.push( this.createPatternReference( pattern.name ) );

		for( j in 0...patterns.length )									// patterns
		{
			var target:PatternReference = result[j];
			var expressions:Array<Array<String>> = cast patterns[j].expressions;

			for( k in 0...expressions.length )							// parallel
			{
				var parallel:PatternListParallel = target.expressions;
				var sequential:PatternListSequential = parallel.expressions[k] = new PatternListSequential();

				for( expr in expressions[k] )							// sequential
				{
					var cardinality:PatternCardinality = this.getPatternCardinality( expr );
					var name:String = this.getPatternName( expr, cardinality );

					var reference:PatternReference = this.getPatternReference( name, result, tokens );

					if( reference == null )
						throw "cannot resolve pattern reference: " + name;

					// --- //

					var clone:PatternReference = reference.clone();		// manipulates the same parallel/sequential
						clone.cardinality = cardinality;				// but has its own cardinality

					sequential.expressions.push( clone );
				}
			}
		}

		// -------------- //

		return result;
	}

	/**
	 *
	 */
	private function getPatternReference( name:String, list:Array<PatternReference>, tokens:Array<TokenType> ):PatternReference
	{
		for( reference in list )
		{
			if( reference.name == name )
				return reference;
		}

		for( token in tokens )
		{
			if( token.name == name )
				return new PatternReference( name, true );
		}

		return null;
	}

	/**
	 *
	 */
	private function createPatternReference( name:String ):PatternReference
	{
		var cardinality:PatternCardinality = this.getPatternCardinality( name );
		var name:String = this.getPatternName( name, cardinality );

		var reference:PatternReference = new PatternReference( name );
			reference.cardinality = cardinality;

		return reference;
	}

	/**
	 *
	 */
	private function getPatternCardinality( name:String ):PatternCardinality
	{
		var cardinality:String = name.charAt( name.length - 1 );

		switch( cardinality )
		{
			case "?": return PatternCardinality.ZERO_ONE;
			case "*": return PatternCardinality.ZERO_N;
			case "+": return PatternCardinality.ONE_N;

			default:
				return PatternCardinality.ONE;
		}
	}

	/**
	 *
	 */
	private function getPatternName( name:String, cardinality:PatternCardinality ):String
	{
		if( cardinality != PatternCardinality.ONE )
			return name.substring( 0, name.length - 1 );

		return name;
	}
}
