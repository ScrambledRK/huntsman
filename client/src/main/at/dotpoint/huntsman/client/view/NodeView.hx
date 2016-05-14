package at.dotpoint.huntsman.client.view;

import openfl.events.Event;
import openfl.events.MouseEvent;
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
	private var label:TextField;

	//
	public var isDragged(default,null):Bool;

	//
	private var isOnStage:Bool;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?label:String )
	{
		super();

		if( label != null )
			this.setLabel( label );

		this.isDragged = false;
		this.isOnStage = true;

		// ----------- //

		this.addEventListener( MouseEvent.MOUSE_DOWN, 	this.onMouseEvent );
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
			this.label.selectable = false;

			this.addChild( this.label );
		}

		this.label.text = label;

		var w2:Float = this.label.width * 0.5;
		var h2:Float = this.label.height * 0.5;

		this.label.x -= w2;
		this.label.y -= h2;

		// ------------ //

		this.graphics.clear();
		this.graphics.beginFill( 0xFFFFFF );

		this.graphics.lineStyle( 1, 0xCCCCCC );
		this.graphics.drawRect( -w2, -h2, w2 * 2, h2 * 2 );
		this.graphics.endFill();
	}

	//
	public function setColor( color:Int ):Void
	{
		if( this.label != null )
			this.label.textColor = color;
	}

	// ------------------------------------------------------ //
	// ------------------------------------------------------ //

	//
	private function onMouseEvent( event:MouseEvent ):Void
	{
		switch( event.type )
		{
			case MouseEvent.MOUSE_DOWN:
				this.openDrag();

			default:
				throw "unhandled mouse event";
		}
	}

	//
	private function onDragEvent( event:Event ):Void
	{
		switch( event.type )
		{
			case MouseEvent.MOUSE_UP:
				this.closeDrag();

			case MouseEvent.MOUSE_OUT:
				this.isOnStage = false;

			case MouseEvent.MOUSE_OVER:
				this.isOnStage = true;

			case Event.MOUSE_LEAVE:
			{
				if( !this.isOnStage )
					this.closeDrag();
			}

			default:
				throw "unhandled mouse event";
		}
	}

	//
	public function openDrag():Void
	{
		if( this.isDragged )
			return;

		this.isDragged = true;
		this.isOnStage = true;

		this.stage.addEventListener( Event.MOUSE_LEAVE, 	this.onDragEvent );
		this.stage.addEventListener( MouseEvent.MOUSE_OUT, 	this.onDragEvent );
		this.stage.addEventListener( MouseEvent.MOUSE_OVER, this.onDragEvent );
		this.stage.addEventListener( MouseEvent.MOUSE_UP, 	this.onDragEvent );
	}

	//
	public function closeDrag():Void
	{
		if( !this.isDragged )
			return;

		this.isDragged = false;
		this.isOnStage = true;

		this.stage.removeEventListener( Event.MOUSE_LEAVE, 		this.onDragEvent );
		this.stage.removeEventListener( MouseEvent.MOUSE_OUT, 	this.onDragEvent );
		this.stage.removeEventListener( MouseEvent.MOUSE_OVER, 	this.onDragEvent );
		this.stage.removeEventListener( MouseEvent.MOUSE_UP, 	this.onDragEvent );
	}


}
