package at.dotpoint.huntsman.client.view;

import haxe.Timer;
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
	private var tooltip:TextField;

	// -------- //

	//
	public var isDragged(default,null):Bool;
	public var isHovered(default,null):Bool;

	//
	private var isOnStage:Bool;

	// -------- //

	//
	private var timer:Timer;
	private var tiptext:String;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?label:String )
	{
		super();

		if( label != null )
			this.setLabel( label );

		this.isDragged = false;
		this.isHovered = false;
		this.isOnStage = true;

		// ----------- //

		this.addEventListener( MouseEvent.MOUSE_DOWN, 	this.onMouseEvent );
		this.addEventListener( MouseEvent.MOUSE_OVER, 	this.onMouseEvent );
		this.addEventListener( MouseEvent.MOUSE_OUT, 	this.onMouseEvent );
		this.addEventListener( MouseEvent.ROLL_OUT, 	this.onMouseEvent );
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

	//
	public function setToolTip( tip:String ):Void
	{
		this.tiptext = tip;
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

			case MouseEvent.MOUSE_OVER, MouseEvent.ROLL_OVER:
				this.openHover();

			case MouseEvent.MOUSE_OUT, MouseEvent.ROLL_OUT:
				this.closeHover();

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

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	//
	public function openHover():Void
	{
		if( this.isHovered || this.isDragged )
			return;

		this.isHovered = true;

		this.timer = new Timer( 1000 );
		this.timer.run = this.onHoverTimer;
	}

	//
	public function closeHover():Void
	{
		if( !this.isHovered )
			return;

		this.isHovered = false;

		if( this.timer != null )
		{
			this.timer.stop();
			this.timer = null;
		}

		if( this.tooltip != null )
		{
			this.removeChild( this.tooltip );
			this.tooltip = null;
		}
	}

	//
	private function onHoverTimer():Void
	{
		this.timer.stop();
		this.timer = null;

		// -------------- //

		this.tooltip = new TextField();
		this.tooltip.selectable 	= false;
		this.tooltip.mouseEnabled 	= false;
		this.tooltip.background 	= true;
		this.tooltip.autoSize = TextFieldAutoSize.LEFT;
		this.tooltip.text = this.tiptext;

		this.tooltip.x =  this.width  * 0.5 + 4;
		this.tooltip.y = -this.height;

		this.addChild( this.tooltip );

		// -------------- //

		this.parent.setChildIndex( this, this.parent.numChildren - 1 );
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	//
	public function openDrag():Void
	{
		this.closeHover();

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
		this.closeHover();

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
