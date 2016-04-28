package at.dotpoint.huntsman.analyser.parser.source;

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
		this.root = new SourceNode();
		this.current = this.root;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function openPattern( pattern:PatternReference ):Void
	{
		trace( ">>", pattern.name );

		var node:SourceNode = new SourceNode( pattern.name );

		this.current.addChildNode( node );
		this.current = node;
	}

	/**
	 *
	 */
	public function saveToken( token:Token ):Void
	{
		trace( token );

		this.current.token.push( token );
	}

	/**
	 *
	 */
	public function closePattern( pattern:PatternReference ):Void
	{
		trace( "<<", pattern.name );

		if( this.current == this.root )
			throw "invalid close pattern, already at root";

		this.current = this.current.parent;
	}
}
