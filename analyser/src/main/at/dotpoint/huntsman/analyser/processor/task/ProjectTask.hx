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

		var current:Node = new Node( "project", this.project.name );
			current.data = this.project;

		this.node.addAssociation( current );

		// ------------ //

		for( variation in this.project.variations )
			this.queueTask( new VariationTask( variation, current ) );

		// ------------ //

		this.clear();
	}
}
