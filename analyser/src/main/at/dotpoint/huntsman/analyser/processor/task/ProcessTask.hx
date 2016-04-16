package at.dotpoint.huntsman.analyser.processor.task;

import at.dotpoint.huntsman.analyser.relation.Node;
import haxe.at.dotpoint.core.dispatcher.event.EventDispatcher;
import haxe.at.dotpoint.core.processor.event.ProcessEvent;
import haxe.at.dotpoint.core.processor.ITask;

/**
 * 15.04.2016
 * @author RK
 */
class ProcessTask extends EventDispatcher implements ITask
{

	/**
	 * identifier of the task, describing its purpose
	 */
	public var type(default, null):String;

	/**
	 * get existing relations and set new relations
	 */
	public var node:Node;

	/**
	 * pending tasks that need execution; resulting from this task execution
	 */
	public var output:Array<ProcessTask>;

	// ----------------------------- //

	/**
	 * current status, cant start a task already processing
	 */
	public var isProcessing(default, null):Bool;

	/**
	 * current status, cant start or complete a task already done
	 */
	public var isComplete(default,null):Bool;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( type:String, node:Node )
	{
		super();

		this.type = type;
		this.node = node;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * starts the actions, fires StatusEvents according to the current state
	 */
	public function execute():Void
	{
		this.isProcessing = true;
		this.isComplete = false;

		this.dispatch( new ProcessEvent( ProcessEvent.TASK_STARTED ) );
	}

	/**
	 * stops and removes any dependencies
	 */
	public function clear():Void
	{
		this.isProcessing = false;
		this.isComplete = true;

		this.dispatch( new ProcessEvent( ProcessEvent.TASK_COMPLETE ) );
	}

	// -------------------------------- //
	// -------------------------------- //

	/**
	 * add pending tasks to the execution queue
	 */
	private function queueTask( task:ProcessTask ):Void
	{
		if( this.output == null )
			this.output = new Array<ProcessTask>();

		this.output.push( task );
	}
}
