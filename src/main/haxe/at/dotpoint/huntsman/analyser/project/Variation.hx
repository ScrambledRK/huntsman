package at.dotpoint.huntsman.analyser.project;

import haxe.io.Path;

/**
 * 15.04.2016
 * @author RK
 */
class Variation
{

    //
    public var name:String;

    //
    public var parser:String;

    //
    public var sources:Array<Path>;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new( ?name:String, ?parser:String )
    {
        this.name = name;
        this.parser = parser;
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    public function toString():String
    {
        return "[Variation:" + this.name + "]";
    }
}
