package at.dotpoint.huntsman.analyser.processor.task;

import at.dotpoint.huntsman.analyser.parser.INodeParser;
import at.dotpoint.huntsman.analyser.project.Variation;
import haxe.io.Path;
import at.dotpoint.huntsman.analyser.relation.Node;
import at.dotpoint.huntsman.analyser.project.Project;

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

		var pnode:Node = new Node( "file", this.file.toString() );
			pnode.data = this.parseFile();

		this.node.addChild( pnode );

		// ------------ //

		//this.clear();
	}

	/**
	 *
	 */
	private function parseFile():Dynamic
	{
		var requested:String = cast( this.node.data, Variation ).parser;
		var parsers:Array<INodeParser> = Main.instance.config.parser;

		for( parser in parsers )
		{
			var isExt:Bool = parser.getSettings().extensions.indexOf( this.file.ext ) != -1;

			if( parser.name == requested && isExt )
				return parser.parse( this.file );
		}

		return null;
	}
}
