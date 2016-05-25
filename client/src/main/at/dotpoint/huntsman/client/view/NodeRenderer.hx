package at.dotpoint.huntsman.client.view;

import haxe.at.dotpoint.math.vector.IVector2;
import Math;
import at.dotpoint.huntsman.common.relation.Node;
import at.dotpoint.huntsman.common.relation.RelationContainer;
import Math;
import haxe.at.dotpoint.core.Timer;
import haxe.ds.Vector;
import haxe.at.dotpoint.math.Trigonometry;
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

	//
	private var bounds:Rectangle;

	// ----------- //

	//
	private var mainView:DisplayObjectContainer;

	//
	private var nodeView:Sprite;

	// ----------- //

	//
	private var lastIndex:Int;

	private var isComplete:Bool;
	private var isMoving:Bool;
	private var isRelaxing:Bool;
	private var isDone:Bool;

	// ----------- //

	private var pool_vec2_1:Vector2;
	private var pool_vec2_2:Vector2;

	private var pool_vecvec2:Vector<Vector2>;

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

		// --------- //

		this.pool_vec2_1 = new Vector2();
		this.pool_vec2_2 = new Vector2();

		this.pool_vecvec2 = new Vector<Vector2>( 2 );

		// --------- //

		this.lastIndex = 0;

		this.isMoving = false;
		this.isRelaxing = false;
		this.isComplete = false;
		this.isDone = false;

		this.reset();
	}

	// ************************************************************************ //
	// Initial Methods
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

	/**
	 *
	 */
	public function addNode( node:Node ):Void
	{
		//if( this.isEmptyNode(node) )
		//	return;

		// -------- //

		var index:Int = this.nodes.addNode( node );

		this.setInitialView( index );
		this.setInitialVertex( index );
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
	private function setInitialView( index:Int ):Void
	{
		var node:Node = this.getNode( index );

		var view:NodeView = this.getView( index );

		if( node.type == "class" )
		{
			view.setLabel( node.name.substring( node.name.lastIndexOf(".") + 1, node.name.length ) );
			view.setColor( node.data.color );
			view.setToolTip( node.name );
		}
		else if( node.type == "file" )
		{
			view.setLabel( node.name.substring( node.name.lastIndexOf("/") + 1, node.name.length ) );
			view.setToolTip( node.type );
		}
		else if( node.type == "platform" )
		{
			view.setLabel( node.name.substring( node.name.lastIndexOf(".") + 1, node.name.length ) );
			view.setToolTip( node.type );
		}
		else
		{
			view.setLabel( node.name );
			view.setToolTip( node.type );
		}

		this.nodeView.addChild( view );
	}

	//
	private function setInitialVertex( index:Int ):Void
	{
		var node:Node = this.getNode( index );

		var connectivity:Float = Math.min( node.getConnectivity(), 15 ) / 15;
		var weight:Float = 1 - connectivity;

		var distance_y:Float = 10 + (this.bounds.height * 0.45) * weight;
		var distance_x:Float = 10 + (this.bounds.width * 0.45)  * weight;

		var x:Float = Math.cos( Math.random() * 2 * Math.PI ) * distance_x + this.bounds.width  * 0.5;
		var y:Float = Math.sin( Math.random() * 2 * Math.PI ) * distance_y + this.bounds.height * 0.5;

		var vertex:NodeVertex = this.getVertex( index );
			vertex.position.x = x;
			vertex.position.y = y;

		// -------------- //

		var view:NodeView = this.getView( index );

		vertex.outerBounds.setDimensions( view.width + 12, view.height + 8 );
		vertex.outerBounds.move( x, y );

		vertex.innerBounds.setDimensions( view.width + 0, view.height + 0 );
		vertex.innerBounds.move( x, y );
	}

	// ************************************************************************ //
	// update Methods
	// ************************************************************************ //

	//
	public function reset():Void
	{
		this.isMoving = true;
		this.isRelaxing = false;
		this.isDone = false;

		for( j in 0...this.nodes.size() )
			this.getVertex(j).relaxation = 0.05;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	public function update():Void
	{
		var sstamp:Float = Timer.stamp();

		do
		{
			if( !this.isDone )
				this.updateVelocity( this.lastIndex );

			this.updatePosition( this.lastIndex );

			// -------------------- //

			this.lastIndex++;

			if( this.lastIndex >= this.nodes.size() )
			{
				this.lastIndex = 0;
				this.isComplete = true;

				//break;
			}
		}
		while( (Timer.stamp() - sstamp) < 20 );

		// ------------------------ //

		if( this.isComplete )
		{
			if( this.isRelaxing )
			{
				if( !this.isMoving )
					this.isRelaxing = false;
			}
			else
			{
				if( !this.isMoving )
					this.isRelaxing = true;
			}

			if( !this.isMoving && !this.isRelaxing )
			{
				this.isDone = true;
			}

			this.isMoving = false;
			this.isComplete = false;
		}

		// ------------------------ //

		this.updateViews();
	}

	/**
	 *
	 */
	private function updateVelocity( index:Int):Void
	{
		var cn:Node = this.getNode( index );

		var cv:NodeVertex = this.getVertex( index );
			cv.force.set( 0, 0 );

		// ------------------- //
		// repulsion:

		for( j in 0...this.nodes.size() )
		{
			if( index == j )
				continue;

			this.setRepulsion( cv, this.getVertex(j) );
		}

		// ------------------- //
		// attraction:

		this.setRelationAttraction( cv, cn.children );
		this.setRelationAttraction( cv, cn.parents );

		// ------------------- //
		// velocity:

		if( isEqual( cv.force.x, 0 ) )
			cv.force.x = 0;

		if( isEqual( cv.force.y, 0 ) )
			cv.force.y = 0;

		cv.velocity.x = (cv.velocity.x + cv.force.x) * 0.85;
		cv.velocity.y = (cv.velocity.y + cv.force.y) * 0.85;

		//if( cv.velocity.length() > 50 )
		//	cv.velocity.normalize();
	}

	//
	private function setRelationAttraction( cv:NodeVertex, container:RelationContainer ):Void
	{
		var types:Array<String> = container.getTypes();

		if( types == null )
			return;

		for( type in types )
		{
			for( j in 0...container.getSize( type ) )
			{
				var pnode:Node = container.getNodeByIndex( type, j );
				var pv:NodeVertex = this.getVertex( pnode.index );

				if( pv != null )
					this.setAttraction( cv, pv );
			}
		}
	}

	/**
	 *
	 */
	private function updatePosition( index:Int ):Void
	{
		var hasMoved:Bool = false;

		var cv:NodeVertex 	= this.getVertex(index);
		var cw:NodeView 	= this.getView(index);

		if( cw.isDragged )
		{
			cv.position.x = this.nodeView.stage.mouseX;
			cv.position.y = this.nodeView.stage.mouseY;

			cv.velocity.set( 0, 0 );
			cv.force.set( 0, 0 );

			hasMoved = true;

			this.reset();
		}
		else
		{
			if( isEqual( cv.velocity.x, 0 ) )
				cv.velocity.x = 0;

			if( isEqual( cv.velocity.y, 0 ) )
				cv.velocity.y = 0;

			cv.position.x += cv.velocity.x;
			cv.position.y += cv.velocity.y;

			if( cv.velocity.x != 0 || cv.velocity.y != 0 )
				hasMoved = true;
		}

		// ---------- //

		if( hasMoved ) 	this.isMoving = true;
		else			return;

		// ---------- //

		var pivot:Vector2 = cv.outerBounds.getPivot( this.pool_vec2_1 );
		var dmove:Vector2 = Vector2.subtract( cv.position, pivot, this.pool_vec2_2 );

		cv.outerBounds.move( dmove.x, dmove.y );
		cv.innerBounds.move( dmove.x, dmove.y );

		// ---------- //

		if( !Rectangle.isRectangleIntersect( this.bounds, cv.innerBounds ) )
		{
			cw.closeDrag();

			if( cw.parent != null )
				this.nodeView.removeChild( cw );
		}
		else
		{
			if( cw.parent == null )
				this.nodeView.addChild( cw );

			cw.x = cv.position.x;
			cw.y = cv.position.y;
		}
	}

	/**
	 *
	 */
	private function updateViews():Void
	{
		var length:Int = this.nodes.size();

		this.nodeView.graphics.clear();
		this.nodeView.graphics.lineStyle( 1, 0x444444 );

		for( i in 0...length )
		{
			var cn:Node = this.getNode(i);

			var types:Array<String> = cn.children.getTypes();

			if( types == null )
				continue;

			for( type in types )
			{
				for( j in 0...cn.children.getSize( type ) )
					this.drawConnection( cn, cn.children.getNodeByIndex( type, j ) );
			}
		}
	}

	// ************************************************************************ //
	// helper Methods
	// ************************************************************************ //

	/**
	 *
	 */
	private function drawConnection( cn:Node, nn:Node ):Void
	{
		var cv:NodeVertex = this.getVertex( cn.index );
		var nv:NodeVertex = this.getVertex( nn.index );

		if( cv == null || nv == null )
			return;

		if( !Rectangle.isRectangleIntersect( this.bounds, cv.innerBounds ) )
			return;

		if( !Rectangle.isRectangleIntersect( this.bounds, nv.innerBounds ) )
			return;

		// --------------- //

		var vertices:Vector<Vector2> = Trigonometry.calculateClosestRectangleVertices( cv.innerBounds, nv.innerBounds, null, this.pool_vecvec2 );

		if( vertices == null )
			return;

		var cp:Vector2 = vertices[0];
		var np:Vector2 = vertices[1];

		this.drawLine( cp, np, 0, 1, 0.5 );
	}

	/**
	 *
	 * @param	a
	 * @param	b
	 * @param	color
	 * @param	thickness
	 * @param	alpha
	 */
	public function drawLine( a:IVector2, b:IVector2, ?color:Int = 0, ?thickness:Float = 1, ?alpha:Float = 1 ):Void
	{
		this.nodeView.graphics.lineStyle( thickness, color, alpha );
		this.nodeView.graphics.beginFill( color, alpha );

		// ----------------- //

		var ax:Float = Std.int( a.x );
		var ay:Float = Std.int( a.y );
		var bx:Float = Std.int( b.x );
		var by:Float = Std.int( b.y );

		// ----------------- //

		var dx:Float = bx - ax;
		var dy:Float = by - ay;
		var dd:Float = Math.sqrt( dx * dx + dy * dy );

		var xm:Float = dd - thickness * 2;
		var xn:Float = dd - thickness * 2;

		var ym:Float =  thickness * 2;
		var yn:Float = -thickness * 2;

		var sin:Float = dy / dd;
		var cos:Float = dx / dd;

		// ----------------- //

		var x0:Float = xm * cos - ym * sin + ax;
		var y0:Float = xm * sin + ym * cos + ay;

		var x1:Float = xn * cos - yn * sin + ax;
		var y1:Float = xn * sin + yn * cos + ay;

		// ----------------- //

		this.nodeView.graphics.moveTo( ax, ay );
		this.nodeView.graphics.lineTo( bx, by );

		this.nodeView.graphics.moveTo( bx, by );
		this.nodeView.graphics.lineTo( x0, y0 );
		this.nodeView.graphics.lineTo( x1, y1 );
		this.nodeView.graphics.lineTo( bx, by );

		this.nodeView.graphics.endFill();
	}

	/**
	 *
	 */
	inline public static function isEqual( a:Float, b:Float ):Bool
	{
		if( a > b )
			return a - b < 0.1;
		else
			return b - a < 0.1;
	}

	/**
	 *
	 */
	private function setRepulsion( cv:NodeVertex, nv:NodeVertex):Void
	{
		var scale:Float = 25;

		var dx:Float = 0;
		var dy:Float = 0;

		// ----------------- //

		dx = cv.position.x - nv.position.x;
		dy = cv.position.y - nv.position.y;

		var dss:Float = ( dx * dx + dy * dy );
		var dsq:Float = Math.sqrt(dss);

		if( dsq > 200 )
			return;

		// ----------------- //

		if( this.isRelaxing )
		{
			var vertices:Vector<Vector2> = Trigonometry.calculateClosestRectangleVertices( cv.outerBounds, nv.outerBounds, null, this.pool_vecvec2 );

			if( vertices == null )
			{
				cv.relaxation = cv.relaxation * 0.25;

				cv.force.x += scale * dx / dss;
				cv.force.y += scale * dy / dss;
			}

			return;
		}

		// ----------------- //

		cv.force.x += scale * dx / dss;
		cv.force.y += scale * dy / dss;
	}

	/**
	 *
	 */
	private function setAttraction( cv:NodeVertex, nv:NodeVertex ):Void
	{
		var scale:Float = cv.relaxation; // 0.05;

		var dx:Float = 0;
		var dy:Float = 0;

		// ----------------- //

		var vertices:Vector<Vector2> = Trigonometry.calculateClosestRectangleVertices( cv.outerBounds, nv.outerBounds, null, this.pool_vecvec2 );

		if( vertices == null )
			return;

		dx = vertices[1].x - vertices[0].x;
		dy = vertices[1].y - vertices[0].y;

//		dx = nv.position.x - cv.position.x;
//		dy = nv.position.y - cv.position.y;

		// ----------------- //

		cv.force.x += scale * dx;
		cv.force.y += scale * dy;
	}
}