package at.dotpoint.huntsman.common.relation;

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
	public var children:RelationContainer;

	//
	public var parents:RelationContainer;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( type:String, ID:String )
	{
		this.ID = ID;
		this.type = type;

		this.children = new RelationContainer();
		this.parents = new RelationContainer();
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
	// toString
	// ************************************************************************ //

	//
	public function toString():String
	{
		return "[N: " + this.type + " - " + this.ID + "]";
	}
}
