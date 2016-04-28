package at.dotpoint.huntsman.analyser.parser.source.pattern;

import at.dotpoint.huntsman.analyser.parser.source.token.TokenProvider;
import at.dotpoint.huntsman.analyser.parser.source.token.Token;

/**
 * 26.04.2016
 * @author RK
 */
class PatternProcessor
{

	//
	public var tokens(default,null):Array<Token>;

	//
	public var settings(default,null):SourceParserSettings;

	//
	public var source(default,null):SourceDOM;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( token:Array<Token>, settings:SourceParserSettings )
	{
		this.tokens = tokens;
		this.settings = settings;

		this.source = new SourceDOM();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function process():Void
	{
		this.settings.patterns.model = this.source;
		this.settings.patterns.test( new TokenProvider( this.tokens ) );
	}
}
