package at.dotpoint.huntsman.analyser.processor.task;

import at.dotpoint.huntsman.analyser.script.ScriptReference;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import sys.io.File;

/**
 * 03.05.2016
 * @author RK
 */
class HScriptTask extends ProcessTask
{

	//
	private var script:ScriptReference;

	//
	public var interpretor(default, null):Interp;

	//
	public var parser:Parser;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( script:ScriptReference )
	{
		super( "hscript" );

		// ------------ //

		this.script = script;

		this.parser = new Parser();

		this.interpretor = new Interp();
		this.interpretor.variables.set( "self", this );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	override public function execute( ):Void
	{
		super.execute( );

		// ------------ //

		trace( ">>", "hscript: " + this.script.name );

		var program:Expr = this.parseScript( );

		try
		{
			this.interpretor.execute( program );
		}
		catch( exception:Dynamic )
		{
			throw "hscript execution error: " + exception;
		}

		trace( "<<" );

		// ------------ //

		this.clear( );
	}

	/**
	 *
	 */
	private function parseScript( ):Expr
	{
		var program:Expr = null;

		try
		{
			var script:String = File.getContent( this.script.path.toString( ) );

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

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	public function setScriptVariable( name:String, value:Dynamic ):Bool
	{
		if( this.interpretor.variables.exists( name ) )
			return false;

		this.interpretor.variables.set( name, value );

		return true;
	}

	/**
	 *
	 */
	public function queueScriptTask( scriptID:String ):HScriptTask
	{
		var script:ScriptReference = Main.instance.config.getScriptReference( scriptID );

		if( script == null )
			throw "cannot queue script task: " + scriptID;

		return cast this.queueTask( new HScriptTask( script ) );
	}
}
