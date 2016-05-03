package at.dotpoint.huntsman.analyser.processor.task;

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

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( parentNode:Node, script:ScriptReference )
	{
		super( "hscript", parentNode );

		// ------------ //

		this.script = script;
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

		trace( "<<" );

		// ------------ //

		this.clear();
	}
}
