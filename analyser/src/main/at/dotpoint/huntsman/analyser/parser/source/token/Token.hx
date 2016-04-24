package at.dotpoint.huntsman.analyser.parser.source.token;

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

	public function new( type:TokenType, ?pos:Int = 0, ?length:Int = 0 )
	{
		this.type = type;

		this.position = pos;
		this.length = length;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function toString():String
	{
		if( this.type == null )
			return "[null-token]";

		return "[" + this.type.name + "]" + this.position + "," + this.length;
	}
}
