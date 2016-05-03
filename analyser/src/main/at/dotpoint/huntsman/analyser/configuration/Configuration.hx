package at.dotpoint.huntsman.analyser.configuration;

import at.dotpoint.huntsman.analyser.script.ScriptReference;
import at.dotpoint.huntsman.analyser.parser.INodeParser;
import at.dotpoint.huntsman.analyser.project.Project;

/**
 * 09.04.2016
 * @author RK
 */
class Configuration {


    //
    public var projects:Array<Project>;

	//
	public var parser:Array<INodeParser>;

	//
	public var scripts:Array<ScriptReference>;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new() {

    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //


}
