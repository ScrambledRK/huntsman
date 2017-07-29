package at.dotpoint.huntsman.analyser.output;

import at.dotpoint.datastructure.graph.GraphContainer;

/**
 *
 */
class JsonOutput implements IOutput
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

//	/**
//	 *
//	 */
//	private function saveNodes( ):Void
//	{
//		var output:String = "{\n";
//
//		// ---------- //
//
//		var container:Map<String, Array<Node>> = this.rootNode.children.container;
//		var keylist:Array<String> = new Array<String>();
//
//		for( key in container.keys( ) )
//		{
//			keylist.push( key );
//
//			output += '  "' + key + '":\n';
//			output += this.createNodeListJson( container.get( key ), 2, true );
//			output += ",\n";
//		}
//
//		// ---------- //
//
//		output += '  "_keys":[';
//
//		for( i in 0...keylist.length )
//		{
//			output += '"' + keylist[i] + '"';
//
//			if( i < keylist.length - 1 )
//				output += ",";
//		}
//
//		output += "]\n}";
//
//		// ---------- //
//
//		File.saveContent( "output_nodes.json", output );
//	}
//
//	/**
//	 *
//	 */
//	private function createNodeListJson( list:Array<Node>, ?level:Int = 0, ?includeAssociations:Bool = false ):String
//	{
//		var output:String = "";
//		var padding:String = "";
//
//		for( j in 0...level )
//			padding += "  ";
//
//		// ------------------------- //
//
//		output += padding + "[\n";
//
//		if( list != null )
//		{
//			for( i in 0...list.length )
//			{
//				output += this.createNodeJson( list[i], level + 1, includeAssociations );
//
//				if( i < list.length - 1 ) output += ",\n";
//				else output += "\n";
//			}
//		}
//
//		output += padding + "]";
//
//		// ------------------------- //
//
//		return output;
//	}
//
//	/**
//	 *
//	 */
//	private function createNodeJson( node:Node, ?level:Int = 0, ?includeAssociations:Bool = false ):String
//	{
//		var output:String = "";
//		var padding:String = "";
//
//		for( j in 0...level )
//			padding += "  ";
//
//		output += padding + "{\n";
//		output += padding + '  "name":"' + node.name + '",\n';
//		output += padding + '  "type":"' + node.type + '"';
//
//		// ------------------------- //
//
//		if( includeAssociations )
//		{
//			output += ",\n";
//
//			output += padding + '  "children":\n';
//			output += this.createNodeListJson( node.children.toArray( ), level + 1, false ) + ",\n";
//
//			output += padding + '  "parents":\n';
//			output += this.createNodeListJson( node.parents.toArray( ), level + 1, false ) + "\n";
//		}
//		else
//		{
//			output += "\n";
//		}
//
//		// ------------------------- //
//
//		output += padding + "}";
//
//		return output;
//	}
}
