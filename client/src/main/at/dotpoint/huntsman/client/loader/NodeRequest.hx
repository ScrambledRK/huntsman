package at.dotpoint.huntsman.client.loader;

import haxe.at.dotpoint.loader.URLRequest;
import js.at.dotpoint.loader.processor.loader.StringLoader;
import haxe.at.dotpoint.loader.DataRequest;

/**
 * 08.05.2016
 * @author RK
 */
class NodeRequest extends DataRequest
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( request:URLRequest )
	{
		super( request, null );

		this.loader = new StringLoader();
		this.parser = new NodeParser();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

}
