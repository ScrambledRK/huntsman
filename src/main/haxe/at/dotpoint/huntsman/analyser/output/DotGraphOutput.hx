package at.dotpoint.huntsman.analyser.output;

import at.dotpoint.datastructure.graph.GraphContainer;
/**
 *
 */
class DotGraphOutput implements IOutput
{


	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( )
	{

	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	public function save( container:GraphContainer ):Void
	{

	}

	/**
	 *
	 */
//	private function printGraph( ):Void
//	{
//		var output:String = "digraph g {\n";
//
//		// ---------- //
//
//		var classes:Array<Node> = this.rootNode.children.container.get( "class" );
//
//		for( node in classes )
//		{
//			var cname:String = node.name.substring( node.name.lastIndexOf( "." ) + 1, node.name.length );
//			var fname:String = node.name.split( "." ).join( "_" );
//
//			output += fname + ' [label="' + cname + '"];\n';
//
//			// ------ //
//
//			var references:Array<Node> = node.children.getAssociationList( "class" );
//
//			if( references == null )
//				continue;
//
//			for( rnode in references )
//			{
//				output += fname + " -> " + rnode.name.split( "." ).join( "_" ) + "\n";
//			}
//		}
//
//		// ---------- //
//
//		output += "\n}";
//
//		File.saveContent( "output_graph.txt", output );
//	}
}
