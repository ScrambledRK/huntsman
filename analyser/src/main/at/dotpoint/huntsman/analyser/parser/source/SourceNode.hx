package at.dotpoint.huntsman.analyser.parser.source;

import at.dotpoint.huntsman.analyser.parser.source.token.Token;

/**
 * 26.04.2016
 * @author RK
 */
class SourceNode
{

	/**
	 *
	 */
	public var children(default,null):Array<SourceNode>;

	/**
	 *
	 */
	public var parent(default,null):SourceNode;

	// ------------- //

	//
	public var name(default,null):String;

	//
	public var token(default,null):Array<Token>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String )
	{
		this.name = name;

		this.children = new Array<SourceNode>();
		this.token = new Array<Token>();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	private function setParent( value:SourceNode ):Void
	{
		this.parent = value;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 * @param	child
	 */
	public function addChildNode( child:SourceNode ):Void
	{
		if( child == null )
			throw "cannot add null-child";

		if( child.parent != null )
			child.parent.removeChildNode( child );

		// --------------- //

		this.children.push( child );
		child.setParent( this );
	}

	/**
	 *
	 * @param	child
	 */
	public function removeChildNode( child:SourceNode ):Bool
	{
		var success:Bool = this.children.remove( child );

		if( success )
			child.setParent( null );

		return success;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 * @param	includeChildren
	 */
	public function hasToken( ?includeChildren:Bool = true ):Bool
	{
		var hasToken:Bool = this.token.length != 0;

		if( hasToken || !includeChildren || this.children.length == 0 )
			return hasToken;

		// ---------------- //

		var hasChildToken:Bool = false;

		for( child in this.children )
		{
			if( child.hasToken(true) )
			{
				hasChildToken = true;
				break;
			}
		}

		return hasToken || hasChildToken;
	}

	//
	public function destoryChildren( ?recursive:Bool = true ):Void
	{
		for( child in this.children )
		{
			if( recursive )
				child.destoryChildren( recursive );

			this.removeChildNode( child );
		}
	}

	//
	public function removeTokens( ?recursive:Bool = true ):Void
	{
		if( this.token.length != 0 )
			this.token = new Array<Token>();

		if( recursive )
		{
			for( child in this.children )
				child.removeTokens( recursive );
		}
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	//
	public function toString():String
	{
		return "[" + this.name + "]";
	}
}
