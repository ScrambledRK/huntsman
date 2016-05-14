package at.dotpoint.huntsman.client;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import at.dotpoint.huntsman.client.view.NodeRenderer;
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
	}

	//
	private function onRequestComplete( event:StatusEvent ):Void
	{
		//
		this.rootNode = cast this.loader.result;

		//
		this.renderer = new NodeRenderer( this );
		this.renderer.reset();

		this.addEventListener( KeyboardEvent.KEY_UP, this.onKeyEvent );
		this.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );

		// --------------- //

		var container:Array<Node> = this.rootNode.children.toArray();

		for( node in container )
		{
			this.renderer.addNode( node );
		}
	}

	//
	private function onKeyEvent( event:KeyboardEvent ):Void
	{
		if( event.keyCode == Keyboard.SPACE )
			this.renderer.reset();
	}

	//
	private function onEnterFrame( event:Event ):Void
	{
		if( this.renderer != null )
			this.renderer.update();
	}
}
