package at.dotpoint.huntsman.analyser.parser.source;

import sys.FileSystem;
import at.dotpoint.huntsman.analyser.relation.Node;
import at.dotpoint.huntsman.analyser.parser.source.Token;
import sys.io.File;
import haxe.io.Path;

/**
 * 16.04.2016
 * @author RK
 */
class SourceParser extends ANodeParser<SourceParserSettings> implements INodeParser
{

	//
	private var content:String;

	//
	private var tokens:Array<Token>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String, settings:SourceParserSettings )
	{
		super( name, "source", settings );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function parse( file:Path ):Array<Node>
	{
		trace( this, "parsing: " + file.toString() );

		// ------------------- //

		this.content = File.getContent( file.toString() );

		this.tokenize();
		this.printTokens();

		// ------------------- //

		return this.getResult();
	}

	/**
	 *
	 */
	private function printTokens():Void
	{
		var output:String = "";

		for( t in this.tokens )
			output += this.content.substr( t.position, t.length );

		File.saveContent( "output.txt", output );
	}

	/**
	 *
	 */
	private function tokenize():Void
	{
		this.tokens = new Array<Token>();

		for( j in 0...this.settings.tokens.length )
		{
			var type:TokenType = settings.tokens[j];

			var exp:EReg = type.expression;
			var cpos:Int = 0;

			while( exp.matchSub( this.content, cpos ) )
			{
				var token:Token = new Token( type );
					token.position = exp.matchedPos().pos;
					token.length = exp.matchedPos().len;

				tokens.push( token );

				cpos = token.position + token.length;
			}
		}

		// ------------------- //

		this.tokens.sort( this.sortTokens );
	}

	/**
	 *
	 */
	private function sortTokens( a:Token, b:Token ):Int
	{
		return a.position - b.position;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function reset():Void
	{
		this.result = null;
		this.tokens = null;
		this.content = null;
	}
}
