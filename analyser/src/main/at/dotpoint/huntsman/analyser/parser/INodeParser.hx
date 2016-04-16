package at.dotpoint.huntsman.analyser.parser;

import haxe.io.Path;
import at.dotpoint.huntsman.analyser.relation.Node;

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

	//
	public function getResult():Array<Node>;

	//
	public function parse( file:Path ):Array<Node>;

	//
	public function reset():Void;
}