package at.dotpoint.huntsman.client;

import openfl.events.Event;
import at.dotpoint.huntsman.client.view.NodeRenderer;
import at.dotpoint.huntsman.client.view.NodeVertex;
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

	//
	private var renderer:NodeRenderer;

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

		this.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
	}

	//
	private function onRequestComplete( event:StatusEvent ):Void
	{
		//
		this.rootNode = cast this.loader.result;

		//
		this.renderer = new NodeRenderer( this );

		// --------------- //

		var container:Array<Node> = this.rootNode.children.toArray();

		for( node in container )
		{
			this.renderer.addNode( node );
		}
	}

	//
	private function onEnterFrame( event:Event ):Void
	{
		if( this.renderer != null )
			this.renderer.update();
	}
}
