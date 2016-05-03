package at.dotpoint.huntsman.analyser.parser;

import at.dotpoint.huntsman.analyser.processor.task.ProcessTask;
import at.dotpoint.huntsman.analyser.relation.Node;
import haxe.at.dotpoint.loader.processor.ADataProcessor;

/**
 * 16.04.2016
 * @author RK
 */
class ANodeParser<TSettings:INodeParserSettings>
{

	//
	public var name:String;

	//
	public var type:String;

	//
	private var settings:TSettings;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String, type:String, ?settings:TSettings )
	{
		this.name = name;
		this.type = type;

		this.settings = settings;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function getSettings():TSettings
	{
		return this.settings;
	}

	// ----------------------------------------------------------------- //
	// ----------------------------------------------------------------- //

	/**
	 *
	 */
	public function toString():String
	{
		return "[Parser:" + this.type + ":" + this.name + "]";
	}

}
