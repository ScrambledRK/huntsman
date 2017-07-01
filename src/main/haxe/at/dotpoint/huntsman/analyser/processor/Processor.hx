package at.dotpoint.huntsman.analyser.processor;

import haxe.at.dotpoint.core.dispatcher.event.EventDispatcher;
import at.dotpoint.huntsman.analyser.processor.task.ProcessTask;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.core.processor.event.ProcessEvent;
import haxe.at.dotpoint.core.processor.AsyncQueue;

/**
 * 15.04.2016
 * @author RK
 */
class Processor extends EventDispatcher
{

	//
	private var queue:AsyncQueue;

	//
	private var progress:ProcessProgress;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	//
	public function new()
	{
		super();

		this.queue = new AsyncQueue();
		this.queue.addListener( ProcessEvent.TASK_STARTED,  this.onTaskEvent );
		this.queue.addListener( ProcessEvent.TASK_COMPLETE, this.onTaskEvent );
		this.queue.addListener( ProcessEvent.PROCESS_STARTED,  this.onProcessEvent );
		this.queue.addListener( ProcessEvent.PROCESS_COMPLETE, this.onProcessEvent );

		this.progress = new ProcessProgress();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function process( tasks:Array<ProcessTask>, onComplete:Event->Void ):Void
	{
		this.addListener( ProcessEvent.PROCESS_COMPLETE, onComplete );

		this.queueTasks( tasks );
		this.queue.process();
	}

	/**
	 *
	 */
	private function onTaskEvent( value:Event ):Void
	{
		var event:ProcessEvent = cast value;
		var task:ProcessTask = cast event.task;

		switch( event.type )
		{
			case ProcessEvent.TASK_COMPLETE:
				this.queueTasks( task.output );

			case ProcessEvent.TASK_STARTED:
				this.progress.printProgress( this.queue.taskList );

			default:
				trace("unknown case: " + event.type );
		}
	}

	/**
	 *
	 */
	private function onProcessEvent( value:Event ):Void
	{
		var event:ProcessEvent = cast value;

		switch( event.type )
		{
			case ProcessEvent.PROCESS_STARTED:
				trace("processing started");

			case ProcessEvent.PROCESS_COMPLETE:
				trace("processing complete");

			default:
				trace("unknown case: " + event.type );
		}

		this.dispatch( value );
	}

	/**
	 *
	 */
	private function queueTasks( tasks:Array<ProcessTask> ):Void
	{
		if( tasks == null || tasks.length == 0 )
			return;

		for( task in tasks )
			this.queue.addTask( task );
	}

}
