package at.dotpoint.huntsman.analyser.output;

import at.dotpoint.datastructure.graph.GraphContainer;

/**
 *
 */
interface IOutput
{
	public function save( container:GraphContainer ):Void;
}
