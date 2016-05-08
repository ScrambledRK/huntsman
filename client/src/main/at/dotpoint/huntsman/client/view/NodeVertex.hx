package at.dotpoint.huntsman.client.view;

import openfl.text.TextFieldAutoSize;
import openfl.text.TextField;
import openfl.display.Sprite;
import haxe.at.dotpoint.math.vector.Vector2;

/**
 * 08.05.2016
 * @author RK
 */
class NodeVertex extends Sprite
{

	//
	public var velocity:Vector2;

	//
	public var force:Vector2;

	// -------- //

	//
	public var label:TextField;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?label:String )
	{
		super();

		this.velocity = new Vector2();
		this.force = new Vector2();

		// --------- //

		if( label != null )
			this.setLabel( label );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function setLabel( label:String )
	{
		if( this.label == null )
		{
			this.label = new TextField();
			this.label.autoSize = TextFieldAutoSize.LEFT;

			this.addChild( this.label );
		}

		this.label.text = label;

		this.label.x -= this.label.width * 0.5;
		this.label.y -= this.label.height * 0.5;

		// ------------ //

		this.graphics.clear();
		this.graphics.lineStyle( 1, 0xFF00001 );
		this.graphics.drawCircle( 0, 0, 5 );
	}
}
