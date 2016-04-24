package at.dotpoint.huntsman.analyser.parser.source;

import at.dotpoint.huntsman.analyser.parser.source.token.Token;
import at.dotpoint.huntsman.analyser.parser.source.token.TokenType;
import at.dotpoint.huntsman.analyser.relation.Node;
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
		var output_content:String = "";
		var output_tokens:String = "";

		for( t in this.tokens )
		{
			output_content += this.content.substr( t.position, t.length );

			if( t.type.name == "newline" )	output_tokens += "\n";
			else							output_tokens += t.type;
		}

		File.saveContent( "output_content.txt", output_content );
		File.saveContent( "output_tokens.txt", output_tokens );
	}

	/**
	 *
	 */
	private function tokenize():Void
	{
		this.tokens = new Array<Token>();

		var spans:Array<Span> = new Array<Span>();

		// ------------------- //
		// test all tokens ...

		for( j in 0...this.settings.tokens.length )
		{
			var type:TokenType = settings.tokens[j];
			var exp:EReg = type.expression;

			var nspans:Array<Span> = new Array<Span>();							// next span list

			if( spans.length == 0 )
				spans[0] = new Span( 0, this.content.length );					// in case previously no span split

			// ------------------- //
			// in all untested content spans ...

			while( spans.length > 0 )
			{
				var tmp:Array<Token> = new Array<Token>();
				var span:Span = spans.pop();

				var cpos:Int = span.min;
				var mpos:Int = span.max;

				// ------------------- //
				// until no matches are found within span

				while( exp.matchSub( this.content.substr(0, mpos), cpos ) )
				{
					var token:Token = new Token( type );
						token.position = exp.matchedPos().pos;
						token.length = exp.matchedPos().len;

					tmp.push( token );

					cpos = token.position + token.length;
				}

				if( tmp.length > 0 )
				{
					this.tokens = this.tokens.concat( tmp );
					nspans = nspans.concat( span.split(tmp) );					// create span list for next tokens
				}
				else
				{
					nspans.push( span );										// ... only reason for sort
				}
			}

			spans = nspans;														// new token type iteration, new spans
			spans.sort( this.sortSpans );
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

	/**
	 *
	 */
	private function sortSpans( a:Span, b:Span ):Int
	{
		return a.min - b.min;
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

class Span
{
	public var min:Int;
	public var max:Int;

	public function new( min:Int, max:Int )
	{
		this.min = min;
		this.max = max;
	}

	/**
	 *
	 */
	public function split( tokens:Array<Token> ):Array<Span>
	{
		var result:Array<Span> = new Array<Span>();

		if( tokens.length == 0 )
			return result;

		// ------------------- //

		tokens = tokens.copy();
		tokens.unshift( new Token(null, this.min, 0) );
		tokens.push( new Token(null, this.max, 0) );

		for( j in 1...tokens.length-1 )
		{
			var pt:Token = tokens[j - 1];
			var ct:Token = tokens[j + 0];
			var nt:Token = tokens[j + 1];

			var ls:Span = new Span( pt.position + pt.length, ct.position );
			var rs:Span = new Span( ct.position + ct.length, nt.position );

			if( j == 1 && ls.getLength() > 0 )		// only first time 2 sides ...
				result.push( ls );

			if( rs.getLength() > 0 )				// afterwards right side is enough
				result.push( rs );
		}

		// ------------------- //

		return result;
	}

	//
	public function getLength():Int
	{
		return this.max - this.min;
	}
}