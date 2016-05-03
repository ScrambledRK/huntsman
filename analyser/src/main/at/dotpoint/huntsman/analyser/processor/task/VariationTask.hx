package at.dotpoint.huntsman.analyser.processor.task;

import haxe.io.Path;
import sys.FileSystem;
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

		this.currentNode  = new Node( "variation", this.variation.name );
		this.currentNode.data = this.variation;

		this.parentNode.addChild( this.currentNode );

		// ------------ //

		for( path in this.variation.sources )
			this.queueFiles( path.toString(), this.currentNode );

		// ------------ //

		this.clear();
	}

	/**
	 *
	 */
	private function queueFiles( file:String, vnode:Node ):Void
	{
		if( FileSystem.isDirectory( file ) )
		{
			var filelist:Array<String> = FileSystem.readDirectory( file );

			for( rfile in filelist )
				this.queueFiles( Path.join([file,rfile]), vnode );
		}
		else
		{
			this.queueTask( new FileTask( new Path(file), vnode ) );
		}
	}
}
