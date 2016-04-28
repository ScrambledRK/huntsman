package at.dotpoint.huntsman.analyser.parser.source.token;

/**
 * 25.04.2016
 * @author RK
 */
class TokenProvider
{

	//
	private var tokens:Array<Token>;

	//
	public var index:Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( tokens:Array<Token> )
	{
		this.tokens = tokens;
		this.index = 0;
	}

	public function clone():TokenProvider
	{
		var clone:TokenProvider = new TokenProvider( this.tokens );
			clone.index = this.index;

		return clone;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function hasNext():Bool
	{
		return this.index < this.tokens.length;
	}

	//
	public function currentToken():Token
	{
		if( !this.hasNext() )
			return null;

		return this.tokens[this.index];
	}

	//
	public function currentType():TokenType
	{
		if( !this.hasNext() )
			return null;

		return this.currentToken().type;
	}

	//
	public function nextToken():Token
	{
		return this.tokens[this.index++];
	}

	//
	public function nextType():TokenType
	{
		return this.nextToken().type;
	}

}
