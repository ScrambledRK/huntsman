package at.dotpoint.huntsman.common.relation;

import haxe.at.dotpoint.math.geom.Rectangle;
import haxe.at.dotpoint.math.vector.Vector2;

/**
 * 08.05.2016
 * @author RK
 */
class NodeVertex
{

	//
	public var position:Vector2;

	//
	public var velocity:Vector2;

	//
	public var force:Vector2;

	//
	public var bounds:Rectangle;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		this.position 	= new Vector2();
		this.velocity 	= new Vector2();
		this.force 		= new Vector2();

		this.bounds = new Rectangle();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

}
