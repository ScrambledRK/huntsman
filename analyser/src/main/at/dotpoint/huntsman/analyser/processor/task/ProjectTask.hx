package at.dotpoint.huntsman.analyser.processor.task;

import at.dotpoint.huntsman.analyser.relation.Node;
import at.dotpoint.huntsman.analyser.project.Project;

/**
 * 16.04.2016
 * @author RK
 */
class ProjectTask extends ProcessTask
{

	//
	private var project:Project;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( project:Project, node:Node )
	{
		super( "project", node );

		// ------------ //

		this.project = project;
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

		var pnode:Node = new Node( "project", this.project.name );
			pnode.data = this.project;

		this.node.addChild( pnode );

		// ------------ //

		for( variation in this.project.variations )
			this.queueTask( new VariationTask( variation, pnode ) );

		// ------------ //

		this.clear();
	}
}
