package at.dotpoint.huntsman.client;

import openfl.display.Sprite;

/**
 * 09.04.2016
 * @author RK
 */
class Main extends Sprite
{

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    public function new()
    {
        super();

        trace("hooray?");

        this.graphics.beginFill(0xFF0000,1);
        this.graphics.drawCircle(100,100,25);
        this.graphics.endFill();
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //


}
