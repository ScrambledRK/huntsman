package at.dotpoint.huntsman.client.loader;

import Std;
import String;
import String;
import String;
import haxe.at.dotpoint.math.color.transform.ColorTransformFormat;
import haxe.at.dotpoint.math.vector.Vector3;
import haxe.at.dotpoint.math.color.transform.ColorTransformRGB;
import haxe.at.dotpoint.math.color.transform.ColorTransformHSV;
import haxe.at.dotpoint.math.color.ColorFormat;
import haxe.at.dotpoint.math.color.ColorUtil;
import flash.Vector;
import haxe.at.dotpoint.math.vector.Vector3;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.Json;
import at.dotpoint.huntsman.common.relation.Node;
import haxe.at.dotpoint.loader.processor.IDataProcessor;
import haxe.at.dotpoint.loader.processor.ADataProcessor;

/**
 * 08.05.2016
 * @author RK
 */
class NodeParser extends ADataProcessor implements IDataProcessor<String,Node>
{
	/**
	 *
	 */
	public var result(default, null):Node;

	//
	private var packages:Array<String>;

	private var hsv:ColorTransformHSV;
	private var rgb:ColorTransformRGB;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();

		this.hsv = new ColorTransformHSV();
		this.rgb = new ColorTransformRGB();
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 *
	 * @param	request
	 */
	public function start( input:String ):Void
	{
		this.setStatus( StatusEvent.STARTED );

		// ----------- //

		this.result = new Node( "root", "root" );

		this.createNodes( Json.parse( input ) );
		this.calculateNodeColors();

		// ----------- //

		this.setStatus( StatusEvent.COMPLETE );
	}

	//
	private function createNodes( json:Dynamic ):Void
	{
		var keys:Array<String> = cast json._keys;

		// create
		for( key in keys )
		{
			var table:Array<Dynamic> = cast Reflect.getProperty( json, key );

			for( entry in table )
				this.getNode( key, entry.name, true );
		}

		// children
		for( key in keys )
		{
			var table:Array<Dynamic> = cast Reflect.getProperty( json, key );

			for( entry in table )
			{
				var nnode:Node = this.getNode( key, entry.name, false );
				var pnode:Node = this.getNode( "platform", nnode.name + getPlatformName(nnode.name), false );

				if( pnode == null )
					pnode = nnode;

				var children:Array<Dynamic> = cast entry.children;

				for( cnode in children )
					pnode.addAssociation( this.getNode( cnode.type, cnode.name ) );
			}
		}
	}

	//
	private function getNode( type:String, name:String, ?create:Bool = true ):Node
	{
		var node:Node = this.result.children.getAssociation( type, name );

		if( node == null && create )
		{
			this.result.addAssociation( node = new Node( type, name ) );

			if( type == "class" )
			{
				this.addPackage( this.getPackageName(name) );

//				for( platform in ["flash","haxe","js","sys","php"] )
//				{
//					if( StringTools.startsWith( name, platform ) )
//					{
//						var pnode:Node = new Node( "platform", name + "." + platform );
//
//						this.result.addAssociation( pnode );
//						node.addAssociation( pnode );
//
//						break;
//					}
//				}
			}

			return node;
		}

		return node;
	}

	//
	private function getPlatformName( name:String ):String
	{
		for( platform in ["flash","haxe","js","sys","php"] )
		{
			if( StringTools.startsWith( name, platform ) )
				return "." + platform;
		}

		return "";
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	//
	private function addPackage( name:String ):Void
	{
		if( this.packages == null )
			this.packages = new Array<String>();

		// ------------------------ //

		if( this.packages.indexOf(name) == -1 )
			this.packages.push( name );
	}

	//
	private function getPackageName( name:String ):String
	{
		return name.substring( 0, name.lastIndexOf(".") );
	}

	//
	private function calculateNodeColors():Void
	{
		if( this.packages == null || this.packages.length == 0 )
			throw "no packages found, could not calculate node colors";

		this.packages.sort( this.sortPackages );

		// ------------ //

		var color:Vector3 = new Vector3();

		var container:Array<Node> = this.result.children.toArray();

		for( node in container )
		{
			if( node.type != "class" )
				continue;

			var pindex:Int = this.packages.indexOf( this.getPackageName(node.name) );

			if( pindex == -1 )
				throw "unexpected node name encountered, could not determine package for: " + node.name;

			// ----------- //

			var relative:Float = this.calculateRelativeColorIndex( pindex );
			this.setRelativeColor( color, relative );

			node.data = { color:ColorUtil.toInt( color, ColorFormat.RGB ) };
		}
	}

	//
	private function setRelativeColor( color:Vector3, value:Float ):Void
	{
		value = Std.int(value * 32) / 32;

		var a:Vector3 = new Vector3( 0, 1, 0.75 );
		var b:Vector3 = new Vector3( 1, 1, 0.75 );

		var c:Vector3 = this.hsv.interpolate( a, b, value );

		this.rgb.convert( c, ColorTransformFormat.HSV, color );
	}

	//
	private function calculateRelativeColorIndex( pindex:Int ):Float
	{
		return pindex / this.packages.length;

		// ------------- //

		var pname:String = this.packages[pindex];

		var rmin:Float = 0;
		var rmax:Float = 1;

		var level:Int = this.getPackageCount( pname );

		for( j in 0...level )
		{
			var neighbors:Array<String> = this.getPackageNeigbors( pname, j);	// sub packages next to current subpackage

			var subname:String = this.getPackageSubstring( pname, j );	// current subpackage
			var subindex:Int = neighbors.indexOf( subname );			// index of c subpackage amongst neighbors

			var tspan:Float = rmax - rmin;								// current possible range
			var rspan:Float = tspan / neighbors.length;					// new range for each subpackage

			rmin += (subindex + 0) * rspan;
			rmax = rmin + (subindex + 1) * rspan;
		}

		return rmin + (rmax - rmin) * 0.5;
	}

	/**
	 *
	 */
	private function getPackageNeigbors( fname:String, level:Int ):Array<String>
	{
		var result:Array<String> = new Array<String>();

		for( pname in this.packages )
		{
			if( !this.isInParentPackage( fname, pname, level ) )
				continue;

			var psub:String = this.getPackageSubstring( pname, level );

			if( result.indexOf(psub) == -1 )
				result.push( psub );
		}

		return result;
	}

	//
	private function isInParentPackage( fname:String, pname:String, level:Int ):Bool
	{
		var count:Int = 0;

		while( count < level )
		{
			var fsub:String = this.getPackageSubstring( fname, count );
			var psub:String = this.getPackageSubstring( pname, count );

			if( fsub != psub )
				return false;

			count++;
		}

		return true;
	}

	//
	private function getPackageSubstring( pname:String, level:Int ):String
	{
		var count:Int 	= -1;
		var sindex:Int 	= -1;
		var eindex:Int 	= -1;

		while( count++ < level )
		{
			sindex = eindex + 1;
			eindex = pname.indexOf( ".", eindex + 1 );
		}

		if( sindex == -1 ) sindex = 0;
		if( eindex == -1 ) eindex = pname.length;

		// --------- //

		return pname.substring( sindex, eindex );
	}

	//
	private function getPackageCount( pname:String ):Int
	{
		var count:Int = 0;
		var index:Int = 0;

		while( index != -1 && count < 100 )
		{
			index = pname.indexOf( ".", index + 1 );
			count++;
		}

		return count;
	}

	//
	private function sortPackages( a:String, b:String ):Int
	{
		a = a.toLowerCase();
	    b = b.toLowerCase();

	    if (a < b) return -1;
	    if (a > b) return 1;

	    return 0;
	}

}
