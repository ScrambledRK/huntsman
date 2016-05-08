package at.dotpoint.huntsman.client.loader;

import at.dotpoint.huntsman.client.relation.NodeVertex;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.Json;
import at.dotpoint.huntsman.common.relation.Node;
import haxe.at.dotpoint.loader.processor.IDataProcessor;
import haxe.at.dotpoint.loader.processor.ADataProcessor;

/**
 * 08.05.2016
 * @author RK
 */
class NodeParser extends ADataProcessor implements IDataProcessor<String,Node>
{
	/**
	 *
	 */
	public var result(default, null):Node;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 *
	 * @param	request
	 */
	public function start( input:String ):Void
	{
		this.setStatus( StatusEvent.STARTED );

		// ----------- //

		this.result = new Node( "root", "root" );
		this.createNodes( Json.parse( input ) );

		// ----------- //

		this.setStatus( StatusEvent.COMPLETE );
	}

	//
	private function createNodes( json:Dynamic ):Void
	{
		var keys:Array<String> = cast json._keys;

		for( key in keys )
		{
			var table:Array<Dynamic> = cast Reflect.getProperty( json, key );

			for( entry in table )
			{
				var node:Node = this.getNode( entry.type, entry.name );
				var children:Array<Dynamic> = cast entry.children;

				for( cnode in children )
					node.addAssociation( this.getNode( cnode.type, cnode.name ) );
			}
		}
	}

	//
	private function getNode( type:String, name:String, ?create:Bool = true ):Node
	{
		var node:Node = this.result.children.getAssociation( type, name );

		if( node == null && create )
		{
			node = new Node( type, name );
			node.data = new NodeVertex();

			this.result.addAssociation( node );
		}

		return node;
	}

}
