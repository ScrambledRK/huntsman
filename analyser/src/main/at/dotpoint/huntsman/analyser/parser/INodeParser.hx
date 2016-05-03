package at.dotpoint.huntsman.analyser.parser;

import at.dotpoint.huntsman.analyser.processor.task.ProcessTask;
import haxe.io.Path;

/**
 * 16.04.2016
 * @author RK
 */
interface INodeParser
{
	//
	public var name:String;

	//
	public var type:String;

	//
	public function getSettings():INodeParserSettings;

	// ------------------------ //
	// ------------------------ //

	//
	public function parse( file:Path, ?task:ProcessTask ):Void;

	//
	public function reset():Void;
}