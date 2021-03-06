package at.dotpoint.huntsman.analyser;


import at.dotpoint.huntsman.analyser.graph.HuntsmanGraph;
import at.dotpoint.dispatcher.event.Event;
import at.dotpoint.logger.logger.TraceLogger;
import at.dotpoint.logger.Log;
import at.dotpoint.huntsman.analyser.configuration.Configuration;
import at.dotpoint.huntsman.analyser.configuration.ConfigurationFactory;
import at.dotpoint.huntsman.analyser.processor.Processor;
import at.dotpoint.huntsman.analyser.processor.task.ProcessTask;
import at.dotpoint.huntsman.analyser.processor.task.ProjectTask;

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
	public var container:HuntsmanGraph;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	/**
     *
     */
	public static function main( )
	{
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
		Sys.exit( 0 );
	}




}
