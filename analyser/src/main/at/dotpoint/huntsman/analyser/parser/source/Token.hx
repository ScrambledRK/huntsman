package at.dotpoint.huntsman.analyser.parser.source;

/**
 * 16.04.2016
 * @author RK
 */
class Token
{

	//
	public var type(default,null):TokenType;

	//
	public var position:Int;
	public var length:Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( type:TokenType)
	{
		this.type = type;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function toString():String
	{
		return "[" + this.type.name + "]";
	}
}
