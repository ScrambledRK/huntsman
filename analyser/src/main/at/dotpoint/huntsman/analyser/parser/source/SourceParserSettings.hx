package at.dotpoint.huntsman.analyser.parser.source;

import at.dotpoint.huntsman.analyser.parser.source.token.TokenType;

/**
 * 16.04.2016
 * @author RK
 */
class SourceParserSettings extends ANodeParserSettings
{

	//
	public var tokens:Array<TokenType>;

	//
	public var patterns:Array<TokenType>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

}
