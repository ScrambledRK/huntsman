package at.dotpoint.huntsman.analyser.processor;

import at.dotpoint.huntsman.analyser.processor.task.ProcessTask;
import at.dotpoint.processor.ITask;
import haxe.Timer;

/**
 * 15.04.2016
 * @author RK
 */
class ProcessProgress
{

	//
	private var timestamp:Float;

	//
	private var timespan:Float;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?initial:Float = 0, ?timespan:Float = 1 )
	{
		this.timestamp = initial;
		this.timespan = timespan;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function printProgress( tasklist:Array<ITask> ):Void
	{
		//if( Timer.stamp() - this.timestamp < 1 )
		//	return;

		this.timestamp = Timer.stamp( );

		// ----------------- //

		var tasks:Map<String, Int> = new Map<String, Int>();

		for( value in tasklist )
		{
			var task:ProcessTask = cast value;

			if( task == null )
				continue;

			if( tasks.exists( task.type ) ) tasks.set( task.type, tasks.get( task.type ) + 1 );
			else tasks.set( task.type, 1 );
		}

		// ------------------ //

		trace( "tasks open: " + tasklist.length );

		var types:Iterator<String> = tasks.keys( );

		for( type in types )
			trace( " - " + type + ": " + tasks.get( type ) );
	}
}
