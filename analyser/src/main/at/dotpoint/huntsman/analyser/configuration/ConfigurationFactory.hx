package at.dotpoint.huntsman.analyser.configuration;

import sys.FileSystem;
import at.dotpoint.huntsman.analyser.script.ScriptReference;
import haxe.io.Path;
import haxe.io.Path;
import haxe.io.Path;
import at.dotpoint.huntsman.analyser.parser.ParserFactory;
import at.dotpoint.huntsman.analyser.parser.INodeParser;
import at.dotpoint.huntsman.analyser.project.ProjectFactory;
import at.dotpoint.huntsman.analyser.project.Project;

/**
 * 09.04.2016
 * @author RK
 */
class ConfigurationFactory
{

    //
    private var projectFactory:ProjectFactory;

    //
    private var parserFactory:ParserFactory;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new( ?projectFactory:ProjectFactory, ?parserFactory:ParserFactory )
    {
        this.projectFactory = projectFactory != null ? projectFactory : new ProjectFactory();
        this.parserFactory = parserFactory != null ? parserFactory : new ParserFactory();
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    /**
     *
     */
    public function createFromJson( configurationJson:Dynamic, configPath:Path ):Configuration
    {
        var configuration:Configuration = new Configuration();
            configuration.projects = this.createProjects( configurationJson );
			configuration.scripts = this.createScripts( configurationJson, configPath );
            configuration.parser = this.createParser( configurationJson, configPath, configuration.scripts );

        return configuration;
    }

    /**
     *
     */
    private function createProjects( configurationJson:Dynamic ):Array<Project>
    {
        var projects:Array<Dynamic> = cast configurationJson.projects;

        if( projects == null || projects.length == 0 )
            throw "must contain non-empty projects array";

        // ---------------- //

        var result:Array<Project> = new Array<Project>();

        for( proj in projects )
            result.push( this.projectFactory.createFromJson( proj ) );

        return result;
    }

	/**
     *
     */
    private function createScripts( configurationJson:Dynamic, configPath:Path ):Array<ScriptReference>
    {
        var scripts:Array<Dynamic> = cast configurationJson.scripts;

        if( scripts == null || scripts.length == 0 )
           return null;

        // ---------------- //

        var result:Array<ScriptReference> = new Array<ScriptReference>();

        for( p in scripts )
        {
            var path:String = Path.join( [ configPath.dir.toString(), StringTools.trim( p.path ) ] );

            if( !FileSystem.exists( path ) )
                throw "script path '" + path + "' does not exist";

            result.push( new ScriptReference( p.name, new Path( path ) ) );
        }

        return result;
    }

    /**
     *
     */
    private function createParser( configurationJson:Dynamic, configPath:Path, scripts:Array<ScriptReference> ):Array<INodeParser>
    {
        var parser:Array<Dynamic> = cast configurationJson.parsers;

        if( parser == null || parser.length == 0 )
            throw "must contain non-empty parser array";

        // ---------------- //

        var result:Array<INodeParser> = new Array<INodeParser>();

        for( p in parser )
            result.push( this.parserFactory.createFromJson( p, new Path(configPath.dir), scripts ) );

        return result;
    }


}