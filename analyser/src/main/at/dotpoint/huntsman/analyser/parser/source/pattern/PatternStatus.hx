package at.dotpoint.huntsman.analyser.parser.source.pattern;

/**
 * 23.04.2016
 * @author RK
 */
class PatternStatus
{
	public var isOpen:Bool;
	public var isConsumed:Bool;
	public var isSuccess:Bool;

	//
	public function new()
	{
		this.isOpen 	= true;
		this.isConsumed = false;
		this.isSuccess 	= false;
	}

	//
	public function clone():PatternStatus
	{
		var clone:PatternStatus = new PatternStatus();
			clone.isOpen = this.isOpen;
			clone.isConsumed = this.isConsumed;
			clone.isSuccess = this.isSuccess;

		return clone;
	}

	public function toString():String
	{
		return "[open:" + this.isOpen + ",success:" + this.isSuccess + ",consumed:"+this.isConsumed+"]";
	}
}
