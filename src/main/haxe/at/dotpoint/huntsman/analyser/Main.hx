package at.dotpoint.huntsman.analyser;

import at.dotpoint.dispatcher.event.Event;
import at.dotpoint.huntsman.analyser.configuration.Configuration;
import at.dotpoint.huntsman.analyser.configuration.ConfigurationFactory;
import at.dotpoint.huntsman.analyser.processor.Processor;
import at.dotpoint.huntsman.analyser.processor.task.ProcessTask;
import at.dotpoint.huntsman.analyser.processor.task.ProjectTask;
import at.dotpoint.huntsman.common.relation.Node;
import at.dotpoint.logger.Log;
import at.dotpoint.logger.logger.TraceLogger;
import haxe.CallStack;
import haxe.io.Path;
import haxe.Json;
import StringTools;
import sys.FileSystem;
import sys.io.File;

/**
 * 09.04.2016
 * @author RK
 */
class Main
{

	//
	public static var instance:Main;

	// ----------------- //

	//
	public var config(default, null):Configuration;

	//
	public var processor(default, null):Processor;

	//
	public var rootNode:Node;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	/**
     *
     */
	public static function main( )
	{
		trace( "init huntsman code analysis" );

		// ------------------- //

		Main.instance = new Main( );

		if( Sys.args( ) == null || Sys.args( ).length < 1 )
			throw "must provide a huntsman config file as a commandline parameter";

		Main.instance.setup( );
		Main.instance.parseConfiguration( Sys.args( )[0] );
	}

	/**
     *
     */
	public function new( )
	{ }

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	private function getConfigurationFactory( ):ConfigurationFactory
	{
		return new ConfigurationFactory();
	}

	// ************************************************************************ //
	// initialize
	// ************************************************************************ //

	/**
	 *
	 */
	private function setup( ):Void
	{
		Log.initialize( [new TraceLogger()] );
	}

	/**
     *
     */
	private function parseConfiguration( configFilePath:String ):Void
	{
		configFilePath = StringTools.trim( configFilePath );

		if( configFilePath.length == 0 )
			throw "empty config path found: must provide valid config file path";

		if( !FileSystem.exists( configFilePath ) )
			throw "given config path does not exist: " + configFilePath;

		// ------------------------ //

		var json:Dynamic = null;

		try
		{
			json = Json.parse( File.getContent( configFilePath ) );
		}
		catch( exception:Dynamic )
		{
			throw "json parse configuration failed:\n" + exception.toString( );
		}

		if( json == null )
			throw "json parse configuration failed: unknown error, json is null";

		// ------------------------ //

		try
		{
			this.config = this.getConfigurationFactory( ).createFromJson( json, new Path( configFilePath ) );
		}
		catch( exception:Dynamic )
		{
			var stack:Array<StackItem> = CallStack.exceptionStack( );

			var msg:String = exception.toString( );
			msg += "\nstack:";

			for( item in stack )
				msg += "\n  " + item;

			throw "create configuration failed:\n" + msg;
		}

		if( this.config == null )
			throw "create configuration failed: unknown error, config is null";

		// ------------------------ //

		this.startAnalysis( );
	}

	// ************************************************************************ //
	// start
	// ************************************************************************ //

	/**
     *
     */
	private function startAnalysis( ):Void
	{
		this.rootNode = new Node( "root", "root" );

		this.processor = new Processor();
		this.processor.process( this.getInitialTasks( ), this.onComplete );
	}

	/**
     *
     */
	private function getInitialTasks( ):Array<ProcessTask>
	{
		var initialTasks:Array<ProcessTask> = new Array<ProcessTask>();

		// ---------------- //

		for( project in this.config.projects )
			initialTasks.push( new ProjectTask( project, this.rootNode ) );

		// ---------------- //

		return initialTasks;
	}

	/**
     *
     */
	private function onComplete( event:Event ):Void
	{
		this.rootNode.print( );

		this.printGraph( );
		this.saveNodes( );

		Sys.exit( 0 );
	}

	/**
	 *
	 */
	private function printGraph( ):Void
	{
		var output:String = "digraph g {\n";

		// ---------- //

		var classes:Array<Node> = this.rootNode.children.container.get( "class" );

		for( node in classes )
		{
			var cname:String = node.name.substring( node.name.lastIndexOf( "." ) + 1, node.name.length );
			var fname:String = node.name.split( "." ).join( "_" );

			output += fname + ' [label="' + cname + '"];\n';

			// ------ //

			var references:Array<Node> = node.children.getAssociationList( "class" );

			if( references == null )
				continue;

			for( rnode in references )
			{
				output += fname + " -> " + rnode.name.split( "." ).join( "_" ) + "\n";
			}
		}

		// ---------- //

		output += "\n}";

		File.saveContent( "output_graph.txt", output );
	}

	/**
	 *
	 */
	private function saveNodes( ):Void
	{
		var output:String = "{\n";

		// ---------- //

		var container:Map<String, Array<Node>> = this.rootNode.children.container;
		var keylist:Array<String> = new Array<String>();

		for( key in container.keys( ) )
		{
			keylist.push( key );

			output += '  "' + key + '":\n';
			output += this.createNodeListJson( container.get( key ), 2, true );
			output += ",\n";
		}

		// ---------- //

		output += '  "_keys":[';

		for( i in 0...keylist.length )
		{
			output += '"' + keylist[i] + '"';

			if( i < keylist.length - 1 )
				output += ",";
		}

		output += "]\n}";

		// ---------- //

		File.saveContent( "output_nodes.json", output );
	}

	/**
	 *
	 */
	private function createNodeListJson( list:Array<Node>, ?level:Int = 0, ?includeAssociations:Bool = false ):String
	{
		var output:String = "";
		var padding:String = "";

		for( j in 0...level )
			padding += "  ";

		// ------------------------- //

		output += padding + "[\n";

		if( list != null )
		{
			for( i in 0...list.length )
			{
				output += this.createNodeJson( list[i], level + 1, includeAssociations );

				if( i < list.length - 1 ) output += ",\n";
				else output += "\n";
			}
		}

		output += padding + "]";

		// ------------------------- //

		return output;
	}

	/**
	 *
	 */
	private function createNodeJson( node:Node, ?level:Int = 0, ?includeAssociations:Bool = false ):String
	{
		var output:String = "";
		var padding:String = "";

		for( j in 0...level )
			padding += "  ";

		output += padding + "{\n";
		output += padding + '  "name":"' + node.name + '",\n';
		output += padding + '  "type":"' + node.type + '"';

		// ------------------------- //

		if( includeAssociations )
		{
			output += ",\n";

			output += padding + '  "children":\n';
			output += this.createNodeListJson( node.children.toArray( ), level + 1, false ) + ",\n";

			output += padding + '  "parents":\n';
			output += this.createNodeListJson( node.parents.toArray( ), level + 1, false ) + "\n";
		}
		else
		{
			output += "\n";
		}

		// ------------------------- //

		output += padding + "}";

		return output;
	}


}
