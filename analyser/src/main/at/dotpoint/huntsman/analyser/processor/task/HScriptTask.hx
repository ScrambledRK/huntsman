package at.dotpoint.huntsman.analyser.processor.task;

import hscript.Expr;
import sys.io.File;
import hscript.Parser;
import hscript.Interp;
import at.dotpoint.huntsman.analyser.relation.Node;
import at.dotpoint.huntsman.analyser.script.ScriptReference;

/**
 * 03.05.2016
 * @author RK
 */
class HScriptTask extends ProcessTask
{

	//
	private var script:ScriptReference;

	//
	public var interpretor(default,null):Interp;

	//
	public var parser:Parser;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( parentNode:Node, script:ScriptReference )
	{
		super( "hscript", parentNode );

		// ------------ //

		this.script = script;

		this.parser = new Parser();
		this.interpretor = new Interp();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	override public function execute():Void
	{
		super.execute();

		// ------------ //

		trace( ">>", "hscript: " + this.script.name );

		var program:Expr = this.parseScript();

		try
		{
			if( !this.interpretor.variables.exists("task") )
				this.interpretor.variables.set( "task", this );

			this.interpretor.execute( program );
		}
		catch( exception:Dynamic )
		{
			throw "hscript execution error: " + exception;
		}

		trace( "<<" );

		// ------------ //

		this.clear();
	}

	/**
	 *
	 */
	private function parseScript():Expr
	{
		var program:Expr = null;

		try
		{
			var script:String = File.getContent( this.script.path.toString() );

			if( script == null || script.length == 0 )
				throw "hscript " + this.script.path + " is empty or null";

			program = this.parser.parseString( script );

			if( program == null )
				throw "unknown error: parsed hscript is null";
		}
		catch( exception:Dynamic )
		{
			throw "hscript parsing error: " + exception;
		}

		return program;
	}
}
