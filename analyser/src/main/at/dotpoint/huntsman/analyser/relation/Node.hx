package at.dotpoint.huntsman.analyser.relation;

/**
 * 16.04.2016
 * @author RK
 */
class Node
{

	//
	public var ID(default,null):String;

	//
	public var type(default,null):String;

	//
	public var data:Dynamic;

	// ------------------------------ //

	//
	private var map:Map<String,Array<Node>>;

	//
	public var parent(default,null):Node;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ID:String, type:String )
	{
		this.ID = ID;
		this.type = type;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function hasChild( type:String, ID:String ):Bool
	{
		return this.getChild( type, ID ) != null;
	}

	/**
	 *
	 */
	public function getChild( type:String, ID:String ):Node
	{
		if( this.map == null )
			return null;

		if( !this.map.exists( type ) )
			return null;

		// --------------- //

		var list:Array<Node> = this.map.get( type );

		if( list == null )
			throw "null node list found in relation container";

		for( n in list )
		{
			if( n.ID == ID )
				return n;
		}

		// --------------- //

		return null;
	}

	/**
	 *
	 */
	public function addChild( node:Node ):Bool
	{
		if( this.hasChild( node.type, node.ID ) )
			return false;

		// --------------- //

		if( this.map == null )
			this.map = new Map<String,Array<Node>>();

		if( !this.map.exists( node.type ) )
			this.map.set( node.type, new Array<Node>() );

		this.map.get( node.type ).push( node );
		node.parent = this;

		// --------------- //

		return true;
	}

	/**
	 *
	 */
	public function removeChild( node:Node ):Bool
	{
		var child:Node = this.getChild( node.type, node.ID );

		if( child == null || child != node )
			return false;

		// --------------- //

		var list:Array<Node> = this.map.get( node.type );
			list.remove( node );

		if( list.length == 0 )
			this.map.remove( node.type );

		node.parent = null;

		// --------------- //

		return true;
	}

	// ************************************************************************ //
	// toString
	// ************************************************************************ //

	//
	public function toString():String
	{
		return "[Node:" + this.type + ":" + this.ID + "]";
	}
}
