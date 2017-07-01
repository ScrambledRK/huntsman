package at.dotpoint.huntsman.analyser.project;

import haxe.io.Path;
import haxe.io.Path;
import sys.FileSystem;

/**
 * 15.04.2016
 * @author RK
 */
class VariationFactory
{

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new( )
    {

    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    /**
     *
     */
    public function createFromJson( variationJson:Dynamic, projectRoot:Path ):Variation
    {
        var name:String = StringTools.trim( variationJson.name );

        if( name == null || name.length == 0 )
            throw "must contain non-empty variation name";

        // --------- //

        var parser:String = StringTools.trim( variationJson.parser );

        if( parser == null || parser.length == 0 )
            throw "must contain non-empty variation parser";

        // --------- //

        var variation:Variation = new Variation( name, parser );
            variation.sources = this.createSources( variationJson, projectRoot );

        return variation;
    }

    /**
     *
     */
    private function createSources( variationJson:Dynamic, projectRoot:Path ):Array<Path>
    {
        var root:String = StringTools.trim( variationJson.root );

        if( root == null || root.length == 0 )
            throw "must contain non-empty root path";

        // --------- //

        var path:String = Path.join( [ projectRoot.toString(), root ] );

        if( !FileSystem.exists( path ) )
            throw "variation root path '" + path + "' does not exist";

        if( !FileSystem.isDirectory( path ) )
           throw "variation root path '" + path + "' is not a directory";

        // --------- //

        var sources:Array<Dynamic> = cast variationJson.sources;

        if( sources == null || sources.length == 0 )
            throw "must contain non-empty sources array";

        // ---------------- //

        var result:Array<Path> = new Array<Path>();

        for( src in sources )
        {
            var srcPath:String = Path.join( [ path.toString(), src ] );

            if( !FileSystem.exists( srcPath ) )
                throw "variation source path '" + srcPath + "' does not exist";

            if( !FileSystem.isDirectory( srcPath ) )
                throw "variation source path '" + srcPath + "' is not a directory";

            result.push( new Path( srcPath ) );
        }

        return result;
    }
}
