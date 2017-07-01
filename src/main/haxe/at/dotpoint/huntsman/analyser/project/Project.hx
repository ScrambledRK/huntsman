package at.dotpoint.huntsman.analyser.project;

import haxe.io.Path;

/**
 * 15.04.2016
 * @author RK
 */
class Project
{

    //
    public var name:String;

    //
    public var root:Path;

    //
    public var variations:Array<Variation>;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new( ?name:String, ?root:Path )
    {
        this.name = name;
        this.root = root;
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    public function toString():String
    {
        return "[Project:" + this.name + "]";
    }
}
