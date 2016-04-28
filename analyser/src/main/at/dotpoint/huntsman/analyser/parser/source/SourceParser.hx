package at.dotpoint.huntsman.analyser.parser.source;

import at.dotpoint.huntsman.analyser.parser.source.pattern.PatternProcessor;
import at.dotpoint.huntsman.analyser.parser.source.token.Token;
import at.dotpoint.huntsman.analyser.parser.source.token.TokenProcessor;
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
	private var tokenizer:TokenProcessor;

	//
	private var patterizer:PatternProcessor;

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

		var content:String 		= File.getContent( file.toString() );

		var tokens:Array<Token> = this.tokenize( content );
		var source:SourceDOM 	= this.patterizer( tokens );

		return this.getResult();
	}

	/**
	 *
	 */
	private function tokenize( content:String ):Array<Token>
	{
		this.tokenizer = new TokenProcessor( content, this.settings );
		this.tokenizer.process();

		// ------------------- //

		this.tokenizer.printTokens();

		// ------------------- //

		return this.tokenizer.tokens;
	}

	/**
	 *
	 */
	private function patterize( tokens:Array<Token> ):SourceDOM
	{
		this.patterizer = new PatternProcessor( tokens, this.settings );
		this.patterizer.process();

		// ------------------- //

		return this.patterizer.source;
	}


	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function reset():Void
	{
		this.result 	= null;
		this.tokenizer 	= null;
		this.patterizer = null;
	}
}

