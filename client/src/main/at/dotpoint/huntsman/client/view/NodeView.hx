package at.dotpoint.huntsman.client.view;

import openfl.text.TextFieldAutoSize;
import openfl.text.TextField;
import flash.display.Sprite;

/**
 * 13.05.2016
 * @author RK
 */
class NodeView extends Sprite
{

	//
	public var label:TextField;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?label:String )
	{
		super();

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

		var w2:Float = this.label.width * 0.5;
		var h2:Float = this.label.height * 0.5;

		this.label.x -= w2;
		this.label.y -= h2;

		// ------------ //

		var padding:Int = 2;

		this.graphics.clear();

		this.graphics.beginFill( 0xFFFFFF );
		this.graphics.drawRect( -w2 - padding, -h2 - padding,
								w2 * 2 + 2 * padding, h2 * 2 + 2 * padding );

		this.graphics.endFill();

		this.graphics.lineStyle( 1, 0xCCCCCC );
		this.graphics.drawRect( -w2, -h2, w2 * 2, h2 * 2 );
	}

}
