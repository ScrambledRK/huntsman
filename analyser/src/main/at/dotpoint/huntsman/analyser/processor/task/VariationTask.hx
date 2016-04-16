package at.dotpoint.huntsman.analyser.processor.task;

import haxe.io.Path;
import at.dotpoint.huntsman.analyser.project.Variation;
import at.dotpoint.huntsman.analyser.relation.Node;

/**
 * 16.04.2016
 * @author RK
 */
class VariationTask extends ProcessTask
{

	//
	private var variation:Variation;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( variation:Variation, node:Node )
	{
		super( "variation", node );

		// ------------ //

		this.variation = variation;
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

		var vnode:Node = new Node( "variation", this.variation.name );
			vnode.data = this.variation;

		this.node.addChild( vnode );

		// ------------ //

		for( path in this.variation.sources )
			this.queueFiles( path );

		// ------------ //

		this.clear();
	}

	/**
	 *
	 */
	private function queueFiles( root:Path ):Void
	{
		//
	}
}
