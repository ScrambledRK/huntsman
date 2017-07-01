package at.dotpoint.huntsman.analyser.project;

import sys.FileSystem;
import haxe.io.Path;
import sys.FileSystem;

/**
 * 15.04.2016
 * @author RK
 */
class ProjectFactory
{

    //
    private var variationFactory:VariationFactory;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new( ?variationFactory:VariationFactory )
    {
        this.variationFactory = variationFactory != null ? variationFactory : new VariationFactory();
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    public function createFromJson( projectJson:Dynamic, configPath:Path ):Project
    {
        var name:String = StringTools.trim( projectJson.name );

        if( name == null || name.length == 0 )
            throw "must contain non-empty project name";

        // --------- //

        var root:String = StringTools.trim( projectJson.root );

        if( root == null || root.length == 0 )
            throw "must contain non-empty root path";

		if( root.charAt(0) == "." )
			root = Path.join( [ FileSystem.absolutePath(configPath.dir), root ] );

        if( !FileSystem.exists( root ) )
            throw "project root path '" + root + "' does not exist";

        if( !FileSystem.isDirectory( root ) )
            throw "project root path '" + root + "' is not a directory";

        // --------- //

        var project:Project = new Project( name, new Path(root) );
            project.variations = this.createVariations( projectJson, project.root );

        return project;
    }

    /**
     *
     */
    private function createVariations( projectJson:Dynamic, projectRoot:Path ):Array<Variation>
    {
        var variations:Array<Dynamic> = cast projectJson.variations;

        if( variations == null || variations.length == 0 )
            throw "must contain non-empty variations array";

        // ---------------- //

        var result:Array<Variation> = new Array<Variation>();

        for( vars in variations )
            result.push( this.variationFactory.createFromJson( vars, projectRoot ) );

        return result;
    }

}
