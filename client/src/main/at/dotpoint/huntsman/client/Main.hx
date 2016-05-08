package at.dotpoint.huntsman.client;

import at.dotpoint.huntsman.client.relation.NodeVertex;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import at.dotpoint.huntsman.common.relation.Node;
import haxe.at.dotpoint.loader.URLRequest;
import at.dotpoint.huntsman.client.loader.NodeRequest;
import openfl.display.Sprite;

/**
 * 09.04.2016
 * @author RK
 */
class Main extends Sprite
{

    //
    public static var instance:Main;

	// ----------------- //

	//
	private var loader:NodeRequest;

	//
	private var rootNode:Node;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new()
    {
        super();

       	Main.instance = this;
		this.initialize( "res/output_nodes.json" );
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

	/**
	 *
	 */
	private function initialize( configURL:String ):Void
	{
		this.loader = new NodeRequest( new URLRequest( configURL ) );
		this.loader.load( this.onRequestComplete );
	}

	//
	private function onRequestComplete( event:StatusEvent ):Void
	{
		this.rootNode = cast this.loader.result;

		// --------------- //

		var container:Array<Node> = this.rootNode.children.toArray();

		for( node in container )
		{
			if( node.type != "class" )
				continue;

			// ----------- //

			var vertex:NodeVertex = cast node.data;
				vertex.x = Math.random() * 1200;
				vertex.y = Math.random() * 900;

			this.addChild( vertex );

			// ----------- //

			vertex.setLabel( this.getLabel( node ) );
		}
	}

	//
	private function getLabel( node:Node ):String
	{
		return node.ID.substring( node.ID.lastIndexOf(".") + 1, node.ID.length );
	}
}
