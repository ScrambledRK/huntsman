package at.dotpoint.huntsman.analyser.parser.source;

import at.dotpoint.huntsman.analyser.processor.task.HScriptTask;
import at.dotpoint.huntsman.analyser.script.ScriptReference;
import at.dotpoint.huntsman.analyser.processor.task.ProcessTask;
import at.dotpoint.huntsman.analyser.parser.source.pattern.PatternProcessor;
import at.dotpoint.huntsman.analyser.parser.source.token.Token;
import at.dotpoint.huntsman.analyser.parser.source.token.TokenProcessor;
import at.dotpoint.huntsman.common.relation.Node;
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

	// ------------------ //

	//
	public var script:ScriptReference;

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
	public function parse( file:Path, ?task:ProcessTask ):Void
	{
		trace( ">>", this, "parsing: " + file.toString() );

		// ------------------- //

		var content:String 		= File.getContent( file.toString() );

		var tokens:Array<Token> = this.tokenize( content );
		var source:SourceDOM 	= this.patterize( tokens );

		// ------------------- //

		if( this.script != null )
			this.executeScript( task, source );

		trace( "<<", this, file.toString() );
		//trace("\n");
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

		this.patterizer.printTokens();

		// ------------------- //

		return this.patterizer.source;
	}

	/**
	 *
	 */
	private function executeScript( task:ProcessTask, source:SourceDOM ):Void
	{
		var node:Node = task.node;

		if( node == null || node.type != "file" )
			throw "unsupported source script node found: " + node;

		// --------------------- //
		// execute:

		var hscript:HScriptTask = new HScriptTask( this.script );
			hscript.setScriptVariable( "source", source.root );
			hscript.node = task.node;

		hscript.execute();

		// --------------------- //
		// queue:

		if( hscript.output != null )
		{
			for( qtask in hscript.output )
				task.queueTask( qtask );
		}
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function reset():Void
	{
		this.tokenizer 	= null;
		this.patterizer = null;
	}
}

