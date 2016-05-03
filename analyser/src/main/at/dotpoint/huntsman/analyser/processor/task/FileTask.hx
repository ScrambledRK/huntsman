package at.dotpoint.huntsman.analyser.processor.task;

import at.dotpoint.huntsman.analyser.script.ScriptReference;
import at.dotpoint.huntsman.analyser.parser.INodeParser;
import at.dotpoint.huntsman.analyser.project.Variation;
import haxe.io.Path;
import at.dotpoint.huntsman.analyser.relation.Node;

/**
 * 16.04.2016
 * @author RK
 */
class FileTask extends ProcessTask
{

	//
	private var file:Path;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( file:Path, node:Node )
	{
		super( "file", node );

		// ------------ //

		this.file = file;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	override public function execute():Void
	{
		super.execute();

		// ------------ //

		this.currentNode = new Node( "file", this.file.toString() );

		var parser:INodeParser = this.getParser();
			parser.parse( this.file, this );

		this.parentNode.addChild( this.currentNode );

		// ------------ //

		//this.clear();
	}

	/**
	 *
	 */
	private function getParser():INodeParser
	{
		var requested:String = cast( this.parentNode.data, Variation ).parser;
		var parsers:Array<INodeParser> = Main.instance.config.parser;

		for( parser in parsers )
		{
			var isExt:Bool = parser.getSettings().extensions.indexOf( this.file.ext ) != -1;

			if( parser.name == requested && isExt )
				return parser;
		}

		throw "could not find parser " + requested + " for file: " + this.file.toString() + " with variation: " + this.parentNode;
		return null;
	}

}
