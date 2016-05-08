package at.dotpoint.huntsman.client;

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
		this.rootNode.print();
	}
}
