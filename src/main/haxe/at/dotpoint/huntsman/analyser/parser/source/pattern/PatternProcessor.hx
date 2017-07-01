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
		this.tokens = token;
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
		var isOpen:Bool = true;

		var root:PatternReference = this.settings.patterns[0];
		var provider:TokenProvider = new TokenProvider( this.tokens );

		while( provider.hasNext() )
		{
			var status:PatternStatus = root.test( provider, this.source );

			if( provider.hasNext() )
				provider.nextToken();
		}
	}

	/**
	 *
	 */
	public function printTokens():Void
	{
		this.source.printNode( this.source.root, true );
	}
}
