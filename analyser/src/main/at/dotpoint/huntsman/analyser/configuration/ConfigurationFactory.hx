package at.dotpoint.huntsman.analyser.configuration;

/**
 * 09.04.2016
 * @author RK
 */
class ConfigurationFactory {


    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new() {

    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    public function createFromJson( configurationJson:Dynamic ):Configuration
    {
        return new Configuration();
    }
}
