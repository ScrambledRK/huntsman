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

	public var result:Array<Token>;

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
/*		trace( ">>", index, pattern, token );

		var node:SourceNode = new SourceNode( pattern.name );

		this.current.addChildNode( node );
		this.current = node;*/
	}

	/**
	 *
	 */
	public function saveToken( token:Token ):Void
	{
		trace( token );

		if( this.result == null )
			this.result = new Array<Token>();

		this.result.push( token );
		//this.current.token.push( token );
	}

	/**
	 *
	 */
	public function closePattern( pattern:PatternReference, status:PatternStatus ):Void
	{
/*		trace( "<<", status );

		if( this.current == this.root )
			throw "invalid close pattern, already at root";

		this.current = this.current.parent;*/
	}

	/**
	 *
	 */
	public function printTokens():Void
	{
		trace("-----------------");

		for( token in this.result )
			trace( token );
	}
}
