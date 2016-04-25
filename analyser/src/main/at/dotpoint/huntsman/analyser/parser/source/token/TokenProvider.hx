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
	public var index(default,null):Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( tokens:Array<Token> )
	{
		this.tokens = tokens;
	}

	public function clone():TokenProvider
	{
		var clone:TokenProvider( this.tokens );
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
		return this.tokens[this.index];
	}

	//
	public function currentType():TokenType
	{
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
