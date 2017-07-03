package at.dotpoint.huntsman.analyser.processor.task;

import at.dotpoint.huntsman.analyser.parser.INodeParser;
import at.dotpoint.huntsman.analyser.project.Variation;
import at.dotpoint.huntsman.common.relation.Node;
import at.dotpoint.logger.Log;
import haxe.io.Path;

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
	override public function execute( ):Void // TODO: remove weird ass current/parent switch
	{
		super.execute( );

		// ------------ //

		var parent:Node = this.node;
		var current:Node = this.getNode( "file", this.file.toString( ), true );

		this.node.addAssociation( current );
		this.node = current;

		// ------------ //

		var parser:INodeParser = this.getParser( parent );

		if( parser != null )
			parser.parse( this.file, this );

		// ------------ //

		this.clear( );
	}

	/**
	 *
	 */
	private function getParser( parent:Node ):INodeParser
	{
		var requested:String = cast( parent.data, Variation ).parser;
		var parsers:Array<INodeParser> = Main.instance.config.parser;

		for( parser in parsers )
		{
			var isExt:Bool = parser.getSettings( ).extensions.indexOf( this.file.ext ) != -1;

			if( parser.name == requested && isExt )
				return parser;
		}

		Log.warn( "could not find parser " + requested + " for file: " + this.file.toString( ) + " with variation: " + parent );

		return null;
	}

}
