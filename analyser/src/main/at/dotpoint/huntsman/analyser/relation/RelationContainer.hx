package at.dotpoint.huntsman.analyser.relation;

/**
 * 03.05.2016
 * @author RK
 */
class RelationContainer
{

	//
	public var container:Map<String,Array<Node>>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( )
	{

	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function hasAssociation( type:String, ID:String ):Bool
	{
		return this.getAssociation( type, ID ) != null;
	}

	/**
	 *
	 */
	public function getAssociation( type:String, ID:String ):Node
	{
		if( this.container == null )
			return null;

		if( !this.container.exists( type ) )
			return null;

		// --------------- //

		var list:Array<Node> = this.container.get( type );

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
	public function addAssociation( node:Node ):Bool
	{
		if( this.hasAssociation( node.type, node.ID ) )
			return false;

		// --------------- //

		if( this.container == null )
			this.container = new Map<String,Array<Node>>();

		if( !this.container.exists( node.type ) )
			this.container.set( node.type, new Array<Node>() );

		this.container.get( node.type ).push( node );

		// --------------- //

		return true;
	}

	/**
	 *
	 */
	public function removeAssociation( node:Node ):Bool
	{
		var child:Node = this.getAssociation( node.type, node.ID );

		if( child == null || child != node )
			return false;

		// --------------- //

		var list:Array<Node> = this.container.get( node.type );
			list.remove( node );

		if( list.length == 0 )
			this.container.remove( node.type );

		// --------------- //

		return true;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	public function getAssociationList( type:String ):Array<Node>
	{
		if( this.container == null )
			return null;

		return this.container.get( type );
	}

}
