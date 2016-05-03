package at.dotpoint.huntsman.analyser;

import haxe.CallStack;
import haxe.at.dotpoint.logger.logger.TraceLogger;
import haxe.at.dotpoint.logger.Log;
import haxe.io.Path;
import at.dotpoint.huntsman.analyser.processor.task.ProjectTask;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import at.dotpoint.huntsman.analyser.processor.task.ProcessTask;
import at.dotpoint.huntsman.analyser.relation.Node;
import at.dotpoint.huntsman.analyser.processor.Processor;
import at.dotpoint.huntsman.analyser.configuration.ConfigurationFactory;
import at.dotpoint.huntsman.analyser.configuration.Configuration;
import sys.io.File;
import haxe.Json;
import sys.FileSystem;
import StringTools;

/**
 * 09.04.2016
 * @author RK
 */
class Main {

    //
    public static var instance:Main;

    // ----------------- //

    //
    public var config(default,null):Configuration;

    //
    public var processor(default,null):Processor;

    //
    public var rootNode:Node;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    /**
     *
     */
    public static function main()
    {
        trace("init huntsman code analysis");

		// ------------------- //

        Main.instance = new Main( );

		if( Sys.args() == null || Sys.args().length < 1 )
		   throw "must provide a huntsman config file as a commandline parameter";

		Main.instance.setup();
		Main.instance.parseConfiguration( Sys.args()[0] );
    }

    /**
     *
     */
    public function new() { }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    private function getConfigurationFactory():ConfigurationFactory
    {
        return new ConfigurationFactory();
    }

    // ************************************************************************ //
    // initialize
    // ************************************************************************ //

	/**
	 *
	 */
    private function setup():Void
	{
		Log.initialize([new TraceLogger()]);
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
            json = Json.parse( File.getContent(configFilePath) );
        }
        catch( exception:Dynamic )
        {
            throw "json parse configuration failed:\n" + exception.toString();
        }

        if( json == null )
            throw "json parse configuration failed: unknown error, json is null";

        // ------------------------ //

        try
        {
            this.config = this.getConfigurationFactory().createFromJson( json, new Path( configFilePath ) );
        }
        catch( exception:Dynamic )
        {
			var stack:Array<StackItem> = CallStack.exceptionStack();

            var msg:String = exception.toString();
                msg += "\nstack:";

			for( item in stack )
				msg += "\n  " + item;

            throw "create configuration failed:\n" + msg;
        }

        if( this.config == null )
            throw "create configuration failed: unknown error, config is null";

        // ------------------------ //

        this.startAnalysis();
    }

	// ************************************************************************ //
	// start
	// ************************************************************************ //

    /**
     *
     */
    private function startAnalysis():Void
    {
        this.rootNode = new Node( "root", "root" );

        this.processor = new Processor();
        this.processor.process( this.getInitialTasks(), this.onComplete );
    }

    /**
     *
     */
    private function getInitialTasks():Array<ProcessTask>
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
		this.printNodes( this.rootNode );
		this.printGraph();

        Sys.exit(0);
    }

	/**
	 *
	 */
	private function printNodes( node:Node, ?depth:Int = 0 ):Void
	{
		var children:Map<String,Array<Node>> = node.children.container;

		if( children == null || depth++ == 2 )
		{
			trace( node );
			return;
		}

		// --------- //

		trace(">>", node );

		for( key in children.keys() )
		{
			var list:Array<Node> = node.children.getAssociationList( key );

			for( cnode in list )
				this.printNodes( cnode, depth );
		}

		trace("<<");
	}

	/**
	 *
	 */
	private function printGraph():Void
	{
		var output:String = "digraph g {\n";

		// ---------- //

		var classes:Array<Node> = this.rootNode.children.container.get("class");

		for( node in classes )
		{
			var cname:String = node.ID.substring( node.ID.lastIndexOf(".") + 1, node.ID.length );
			var fname:String = node.ID.split(".").join("_");

			output += fname + ' [label="' + cname + '"];\n';

			// ------ //

			var references:Array<Node> = node.children.getAssociationList("class");

			if( references == null )
				continue;

			for( rnode in references )
			{
				output += fname + " -> " + rnode.ID.split(".").join("_") + "\n";
			}
		}

		// ---------- //

		output += "\n}";

		File.saveContent( "output_graph.txt", output );
	}
}
