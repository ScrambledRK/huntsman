package at.dotpoint.huntsman.analyser.configuration;

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

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new( ?projectFactory:ProjectFactory )
    {
        this.projectFactory = projectFactory != null ? projectFactory : new ProjectFactory();
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    /**
     *
     */
    public function createFromJson( configurationJson:Dynamic ):Configuration
    {
        var configuration:Configuration = new Configuration();
            configuration.projects = this.createProjects( configurationJson );

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
}