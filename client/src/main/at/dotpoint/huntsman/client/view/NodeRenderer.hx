package at.dotpoint.huntsman.client.view;

import openfl.Lib;
import haxe.at.dotpoint.math.geom.Rectangle;
import at.dotpoint.huntsman.common.relation.NodeVertex;
import haxe.at.dotpoint.math.vector.Vector2;
import at.dotpoint.huntsman.common.relation.Node;
import openfl.display.Sprite;
import openfl.display.DisplayObjectContainer;

/**
 * 08.05.2016
 * @author RK
 */
class NodeRenderer
{

	//
	private var nodes:NodeContainer;

	// ----------- //

	//
	private var mainView:DisplayObjectContainer;

	//
	private var nodeView:Sprite;

	// ----------- //

	//
	private var bounds:Rectangle;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( mainContainer:DisplayObjectContainer )
	{
		this.mainView = mainContainer;
		this.nodeView = new Sprite();

		this.mainView.addChild( this.nodeView );

		// --------- //

		this.nodes = new NodeContainer();

		this.bounds = new Rectangle();
		this.bounds.width  = this.mainView.stage.stageWidth;
		this.bounds.height = this.mainView.stage.stageHeight;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	inline public function getNode( index:Int ):Node
	{
		return this.nodes.getNode( index );
	}

	//
	inline public function getView( index:Int ):NodeView
	{
		return this.nodes.getView( index );
	}

	//
	inline public function getVertex( index:Int ):NodeVertex
	{
		return this.nodes.getVertex( index );
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	//
	public function addNode( node:Node ):Void
	{
		if( this.isEmptyNode(node) )
			return;

		// -------- //

		var index:Int = this.nodes.addNode( node );

		this.setInitialVertexPosition( index );
		this.setView( index );
	}

	//
	private function isEmptyNode( node:Node ):Bool
	{
		var parents:Array<Node> = node.parents.toArray();
		var children:Array<Node> = node.children.toArray();

		if( parents == null )
			return true;

		if( parents.length == 1 && parents[0].type == "root" && children == null )
			return true;

		return false;
	}

	//
	private function setView( index:Int ):Void
	{
		var node:Node = this.getNode( index );

		var view:NodeView = this.getView( index );
			view.setLabel( node.name.substring( node.name.lastIndexOf(".") + 1, node.name.length ) );

		this.nodeView.addChild( view );
	}

	//
	private function setInitialVertexPosition( index:Int ):Void
	{
		var node:Node = this.getNode( index );

		var weight:Float = 1 - (Math.min( node.getConnectivity( "class" ), 15 ) / 15);

		var distance_y:Float = 10 + (this.bounds.height * 0.35) * weight;
		var distance_x:Float = 10 + (this.bounds.width * 0.35)  * weight;

		var x:Float = Math.cos( Math.random() * 2 * Math.PI ) * distance_x + this.bounds.width  * 0.5;
		var y:Float = Math.sin( Math.random() * 2 * Math.PI ) * distance_y + this.bounds.height * 0.5;

		var vertex:NodeVertex = this.getVertex( index );
			vertex.position.x = x;
			vertex.position.y = y;

		this.getView( index ).x = x;
		this.getView( index ).y = y;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	//
	public function update():Void
	{
		var length:Int = this.nodes.size();

		for( i in 0...length )
		{
			var cn:Node = this.getNode( i );

			var cv:NodeVertex = this.getVertex( i );
				cv.force.set( 0, 0 );

			// ------------------- //
			// repulsion:

			for( j in 0...length )
			{
				if( i == j )
					continue;

				this.setRepulsion( cv, this.getVertex(j) );
			}

			// ------------------- //
			// attraction:

			//
			var children:Array<Node> = cn.children.toArray();

			if( children != null )
			{
				for( j in 0...children.length )
					this.setAttraction( cv, this.getVertex(children[j].index) );
			}

			//
			var parents:Array<Node> = cn.parents.toArray();

			if( parents != null )
			{
				for( j in 0...parents.length )
				{
					if( parents[j].type != "root" )
						this.setAttraction( cv, this.getVertex(parents[j].index) );
				}
			}

			// ------------------- //
			// velocity:

			if( isEqual( cv.force.x, 0 ) )
				cv.force.x = 0;

			if( isEqual( cv.force.y, 0 ) )
				cv.force.y = 0;

			cv.velocity.x = (cv.velocity.x + cv.force.x) * 0.85;
			cv.velocity.y = (cv.velocity.y + cv.force.y) * 0.85;
		}

		// ----------------------- //
		// positions:

		for( i in 0...length )
		{
			var cv:NodeVertex = this.getVertex(i);

			if( isEqual( cv.velocity.x, 0 ) )
				cv.velocity.x = 0;

			if( isEqual( cv.velocity.y, 0 ) )
				cv.velocity.y = 0;

			cv.position.x += cv.velocity.x;
			cv.position.y += cv.velocity.y;

			// ---------- //

			var cw:NodeView = this.getView(i);
				cw.x = cv.position.x;
				cw.y = cv.position.y;
		}

		// ----------------------- //
		// edges:

		this.nodeView.graphics.clear();
		this.nodeView.graphics.lineStyle( 2, 0x444444 );

		for( i in 0...length )
		{
			var cn:Node 	= this.getNode(i);
			var cw:NodeView = this.getView(i);

			var children:Array<Node> = cn.children.toArray();

			if( children != null )
			{
				for( j in 0...children.length )
				{
					var nw:NodeView = this.getView( children[j].index );

					this.nodeView.graphics.moveTo( cw.x, cw.y );
					this.nodeView.graphics.lineTo( nw.x, nw.y );
				}
			}
		}
	}

	inline public static function isEqual( a:Float, b:Float ):Bool
	{
		if( a > b )
			return a - b < 0.1;
		else
			return b - a < 0.1;
	}

	//
	private function setRepulsion( cv:NodeVertex, nv:NodeVertex ):Void
	{
		var dx:Float = cv.position.x - nv.position.x;
		var dy:Float = cv.position.y - nv.position.y;

		var ds:Float = ( dx * dx + dy * dy );

		cv.force.x += 15 * dx / ds;
		cv.force.y += 15 * dy / ds;
	}

	//
	private function setAttraction( cv:NodeVertex, nv:NodeVertex ):Void
	{
		var dx:Float = nv.position.x - cv.position.x;
		var dy:Float = nv.position.y - cv.position.y;

		cv.force.x += 0.05 * dx;
		cv.force.y += 0.05 * dy;
	}
}
