package at.dotpoint.huntsman.analyser.script;

import haxe.io.Path;

/**
 * 03.05.2016
 * @author RK
 */
class ScriptReference
{

	//
	public var name(default,null):String;

	//
	public var path(default,null):Path;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String, path:Path )
	{
		this.name = name;
		this.path = path;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

}
