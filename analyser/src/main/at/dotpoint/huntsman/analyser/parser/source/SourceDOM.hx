package at.dotpoint.huntsman.analyser.parser.source;

import at.dotpoint.huntsman.analyser.parser.source.pattern.PatternStatus;
import at.dotpoint.huntsman.analyser.parser.source.pattern.PatternReference;
import at.dotpoint.huntsman.analyser.parser.source.token.Token;

/**
 * 26.04.2016
 * @author RK
 */
class SourceDOM
{

	//
	public var root(default,null):SourceNode;

	//
	private var current:SourceNode;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( )
	{
		this.root = new SourceNode( "root" );
		this.current = this.root;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function openPattern( pattern:PatternReference, token:Token, index:Int ):Void
	{
		trace( ">>", index, pattern, token );

		var node:SourceNode = new SourceNode( pattern.name );

		this.current.addChildNode( node );
		this.current = node;
	}

	/**
	 *
	 */
	public function saveToken( token:Token ):Void
	{
		trace( "consumed:", token );

		this.current.token.push( token );
	}

	public function removeTokens():Void
	{
		trace( "backtrack", this.current );

		this.current.removeTokens(true);
		this.current.destoryChildren(true);
	}

	/**
	 *
	 */
	public function closePattern( pattern:PatternReference, status:PatternStatus ):Void
	{
		trace( "<<", status );

		if( this.current == this.root )
			throw "invalid close pattern, already at root";

		// -------------- //

		//if( !status.isSuccess && this.current.hasToken(false) )

		// -------------- //

		if( !this.current.hasToken(true) )
		{
			this.current.destoryChildren();

			if( this.current.parent != null )
			{
				var parent:SourceNode = this.current.parent;
					parent.removeChildNode( this.current );

				this.current = parent;
			}
		}
		else
		{
			this.current = this.current.parent;
		}
	}

	/**
	 *
	 */
	public function printNode( node:SourceNode, ?includeChildren:Bool = true ):Void
	{
		trace( ">>", node );

		if( node != null )
		{
			for( token in node.token )
				trace( token );

			if( includeChildren && node.children.length > 0 )
			{
				for( child in node.children )
					this.printNode( child, includeChildren );
			}
		}

		trace( "<<" );
	}

}
