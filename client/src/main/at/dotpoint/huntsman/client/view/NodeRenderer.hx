package at.dotpoint.huntsman.client.view;

import haxe.at.dotpoint.math.MathUtil;
import haxe.at.dotpoint.math.vector.Vector2;
import at.dotpoint.huntsman.client.view.NodeVertex;
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
	private var mainContainer:DisplayObjectContainer;

	//
	private var nodeContainer:Sprite;

	// ----------- //

	//
	private var nodes:Array<Node>;

	//
	private var vertices:Array<NodeVertex>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( mainContainer:DisplayObjectContainer )
	{
		this.mainContainer = mainContainer;
		this.nodeContainer = new Sprite();

		this.mainContainer.addChild( this.nodeContainer );

		// --------- //

		this.nodes = new Array<Node>();
		this.vertices = new Array<NodeVertex>();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function addNode( node:Node ):Void
	{
		var vertex:NodeVertex = cast node.data;
			vertex.x = 500 + Math.random() * 400;
			vertex.y = 500 + Math.random() * 400;

		this.nodeContainer.addChild( vertex );

		// ----------- //

		this.nodes.push( node );
		this.vertices.push( vertex );

		// ----------- //

		vertex.setLabel( this.getLabel( node ) );
	}

	//
	private function getLabel( node:Node ):String
	{
		return node.ID.substring( node.ID.lastIndexOf(".") + 1, node.ID.length );
	}

	//
	public function update():Void
	{
		for( i in 0...this.nodes.length )
		{
			var cn:Node = this.nodes[i];

			var cv:NodeVertex = this.vertices[i];
				cv.force.set( 0, 0 );

			// ------------------- //
			// repulsion:

			for( j in 0...this.nodes.length )
			{
				if( i == j )
					continue;

				this.setRepulsion( cv, this.vertices[j] );
			}

			// ------------------- //
			// attraction:

			var children:Array<Node> = cn.children.toArray();

			if( children != null )
			{
				for( j in 0...children.length )
					this.setAttraction( cv, cast children[j].data );
			}

			var parents:Array<Node> = cn.parents.toArray();

			if( parents != null )
			{
				for( j in 0...parents.length )
				{
					if( parents[j].data != null )
						this.setAttraction( cv, cast parents[j].data );
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

		for( i in 0...this.nodes.length )
		{
			var cv:NodeVertex = this.vertices[i];

			if( isEqual( cv.velocity.x, 0 ) )
				cv.velocity.x = 0;

			if( isEqual( cv.velocity.y, 0 ) )
				cv.velocity.y = 0;

			cv.x += cv.velocity.x;
			cv.y += cv.velocity.y;
		}

		// ----------------------- //
		// edges:

		this.nodeContainer.graphics.clear();
		this.nodeContainer.graphics.lineStyle( 2, 0x444444 );

		for( i in 0...this.nodes.length )
		{
			var cn:Node = this.nodes[i];
			var cv:NodeVertex = this.vertices[i];

			var children:Array<Node> = cn.children.toArray();

			if( children != null )
			{
				for( j in 0...children.length )
				{
					var nv:NodeVertex = cast children[j].data;

					this.nodeContainer.graphics.moveTo( cv.x, cv.y );
					this.nodeContainer.graphics.lineTo( nv.x, nv.y );
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
		var dx:Float = cv.x - nv.x;
		var dy:Float = cv.y - nv.y;

		var ds:Float = ( dx * dx + dy * dy );

		cv.force.x += 15 * dx / ds;
		cv.force.y += 15 * dy / ds;
	}

	//
	private function setAttraction( cv:NodeVertex, nv:NodeVertex ):Void
	{
		var dx:Float = nv.x - cv.x;
		var dy:Float = nv.y - cv.y;

		cv.force.x += 0.05 * dx;
		cv.force.y += 0.05 * dy;
	}
}
