package at.dotpoint.huntsman.common.relation;

/**
 * 16.04.2016
 * @author RK
 */
import Array;
class Node
{

	//
	public var index:Int;

	//
	public var name(default,null):String;

	//
	public var type(default,null):String;

	//
	public var data:Dynamic;

	// ------------------------------ //

	//
	public var children:RelationContainer;

	//
	public var parents:RelationContainer;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( type:String, name:String, ?index:Int )
	{
		this.name = name;
		this.type = type;

		this.children = new RelationContainer();
		this.parents = new RelationContainer();

		this.index = index;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function addAssociation( node:Node ):Bool
	{
		if( node == null )
			return false;

		var success:Bool = this.children.addAssociation( node );

		if( success )
			node.parents.addAssociation( this );

		// --------------- //

		return success;
	}

	/**
	 *
	 */
	public function removeAssociation( node:Node ):Bool
	{
		var success:Bool = this.children.removeAssociation( node );

		if( success )
			node.parents.removeAssociation( this );

		// --------------- //

		return success;
	}

	// ************************************************************************ //
	// calculations
	// ************************************************************************ //

	//
	public function getConnectivity( ?calculateRecursive:Bool = true ):Int
	{
		var types:Array<String> = this.children.getTypes();

		if( types == null )
			return 0;

		// ------------------ //

		var weight:Int = 0;

		for( type in types )
			weight += this.getConnectivityByType( type, calculateRecursive );

		return weight;
	}

	//
	public function getConnectivityByType( type:String, ?calculateRecursive:Bool = true ):Int
	{
		var cc:Int = this.calculateConnectivity( this.children, type, calculateRecursive );
		var cp:Int = this.calculateConnectivity( this.parents,  type, calculateRecursive );

		return cc + cp;
	}

	//
	private function calculateConnectivity( container:RelationContainer, type:String, ?calculateRecursive:Bool = true, ?visited:Array<Node> )
	{
		var children:Array<Node> = container.getAssociationList( type );

		if( children == null )
			return 0;

		// ---------- //

		if( visited == null )
			visited = new Array<Node>();

		visited.push( this );

		// ---------- //

		var weight:Int = children.length;

		if( !calculateRecursive )
			return weight;

		for( node in children )
		{
			if( visited.indexOf( node ) != -1 )
				continue;

			weight += node.calculateConnectivity( container, type, calculateRecursive, visited );
		}

		return weight;
	}

	// ************************************************************************ //
	// toString
	// ************************************************************************ //

	/**
	 *
	 */
	public function print( ?maxDepth:Int = 2 ):Void
	{
		this.printNodes( this, 0, maxDepth );
	}

	/**
	 *
	 */
	private function printNodes( node:Node, ?depth:Int = 0, ?maxDepth:Int = 2 ):Void
	{
		var children:Map<String,Array<Node>> = node.children.container;

		if( children == null || depth++ == maxDepth )
		{
			trace( node );
			return;
		}

		// --------- //

		trace(">>", node );

		for( key in children.keys() )
		{
			var list:Array<Node> = node.children.getAssociationList( key );

			for( cnode in list )
				this.printNodes( cnode, depth, maxDepth );
		}

		trace("<<");
	}

	//
	public function toString():String
	{
		return "[N: " + this.type + " - " + this.name + "]";
	}
}
