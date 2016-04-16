package at.dotpoint.huntsman.analyser;

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
    private static var instance:Main;

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
        Main.instance = new Main( Sys.args() );
    }

    /**
     *
     */
    public function new( arguments:Array<String> )
    {
        if( arguments == null || arguments.length < 1 )
           throw "must provide a huntsman config file as a commandline parameter";

        this.parseConfiguration( arguments[0] );
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    private function getConfigurationFactory():ConfigurationFactory
    {
        return new ConfigurationFactory();
    }

    // ************************************************************************ //
    // initialize/start analysis
    // ************************************************************************ //

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
            throw "create configuration failed:\n" + exception.toString();
        }

        if( this.config == null )
            throw "create configuration failed: unknown error, config is null";

        // ------------------------ //

        this.startAnalysis();
    }

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
        Sys.exit(0);
    }
}
