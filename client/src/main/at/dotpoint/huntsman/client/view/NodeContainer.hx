package at.dotpoint.huntsman.client.view;

import at.dotpoint.huntsman.common.relation.NodeVertex;
import at.dotpoint.huntsman.common.relation.Node;

/**
 * 13.05.2016
 * @author RK
 */
class NodeContainer
{

	//
	private var datas:Array<Node>;

	//
	private var views:Array<NodeView>;

	//
	private var vertices:Array<NodeVertex>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		this.datas 		= new Array<Node>();
		this.views 		= new Array<NodeView>();
		this.vertices 	= new Array<NodeVertex>();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function addNode( data:Node ):Int
	{
		data.index = this.size();

		this.datas[data.index] 		= data;
		this.views[data.index] 		= new NodeView();
		this.vertices[data.index] 	= new NodeVertex();

		return data.index;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	//
	inline public function size():Int
	{
		return this.datas.length;
	}

	//
	inline public function getNode( index:Int ):Node
	{
		return this.datas[index];
	}

	//
	inline public function getView( index:Int ):NodeView
	{
		return this.views[index];
	}

	//
	inline public function getVertex( index:Int ):NodeVertex
	{
		return this.vertices[index];
	}
}
