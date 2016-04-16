package at.dotpoint.huntsman.analyser.parser.source;

/**
 * 16.04.2016
 * @author RK
 */
class TokenType
{

	//
	public var name(default,null):String;

	//
	public var expression(default,null):EReg;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String, expression:EReg )
	{
		this.name = name;
		this.expression = expression;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	public function toString():String
	{
		return "[" + this.name + "]";
	}
}
