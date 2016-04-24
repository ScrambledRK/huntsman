package at.dotpoint.huntsman.analyser.parser.source.pattern;

import at.dotpoint.huntsman.analyser.parser.source.pattern.PatternStatus;
import at.dotpoint.huntsman.analyser.parser.source.token.TokenType;

/**
 * 22.04.2016
 * @author RK
 */
class PatternReference
{

	// pattern / token name
	public var name(default,null):String;

	// ?, *, +, 1
	public var cardinality(default,null):PatternCardinality;

	// open, success, failure
	public var status(default,null):PatternStatus;

	// ------------------ //

	// parallel -> sequential -> reference
	public var expressions:PatternListParallel;

	// tmp clone of expressions
	public var testing:PatternListParallel;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String )
	{
		this.name = name;

		this.cardinality = PatternCardinality.ONE;
		this.status = PatternStatus.OPEN;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	//
	public function isTokenReference():Bool
	{
		return this.expressions == null;
	}

	//
	public function isOptional():Bool
	{
		return this.cardinality == PatternCardinality.ZERO_N || this.cardinality == PatternCardinality.ZERO_ONE;
	}

	//
	public function isRecurring():Bool
	{
		return this.cardinality == PatternCardinality.ZERO_N || this.cardinality == PatternCardinality.ONE_N;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	public function test( token:TokenType ):PatternStatus
	{
		if( !this.status == PatternStatus.OPEN )
			throw "already completed pattern (status != open): reference";

		// ------------------------- //
		// testing:

		if( this.isTokenReference() )										// leaf node, decide!
		{
			if( this.name == token.name ) 	this.status = PatternStatus.SUCCESS;
			else							this.status = PatternStatus.FAILURE;
		}
		else
		{
			if( this.testing == null )
				this.testing = this.expressions.clone();					// test pattern (parallel->sequence->...)

			this.status = this.testing.test( token );
		}

		if( this.status == PatternStatus.SUCCESS && this.isRecurring() )	// multiple possible, set to open again
			this.reset();

		if( this.status == PatternStatus.FAILURE && this.isOptional() )
			this.status = PatternStatus.SUCCESS;

		// ------------------------- //

		var result:PatternStatus = this.status;

		if( this.status != PatternStatus.OPEN )
			this.reset();

		return result;
	}

	// shallow copy
	public function clone():PatternReference
	{
		var clone:PatternReference = new PatternReference( this.name );
			clone.cardinality = this.cardinality;
			clone.expressions = this.expressions;

		return clone;
	}

	//
	private function reset():Void
	{
		this.testing = null;
		this.status = PatternStatus.OPEN;
	}

	// ************************************************************************ //
	// toString
	// ************************************************************************ //

	//
	public function toString():String
	{
		return "[" + this.name + "]";
	}

}

/**
 *
 */
class PatternListParallel
{
	// open, success, failure
	public var status(default,null):PatternStatus;

	// ------------------ //

	// sequential -> reference
	public var expressions:Array<PatternListSequential>;

	// tmp clone of expressions
	public var testing:Array<PatternListSequential>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		this.status = PatternStatus.OPEN;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * all sequential patterns fail = fail for parallel
	 * any sequential pattern success = success for parallel
	 * any sequential pattern open = open for parallel
	 */
	public function test( token:TokenType ):PatternStatus
	{
		if( !this.status == PatternStatus.OPEN )
			throw "already completed pattern (status != open): parallel";

		// ------------------------- //
		// shallow copy for testing

		if( this.testing == null )
		{
			this.testing = new Array<PatternListSequential>();

			for( j in 0...this.expressions.length )
				this.testing[j] = this.expressions[j].clone();
		}

		// ------------------------- //
		// testing all sequences

		this.status = PatternStatus.FAILURE;							// any sequential must be open or successful

		for( sequential in this.testing )
		{
			if( sequential.status != PatternStatus.OPEN )
				continue;

			// --------------------- //

			var status:PatternStatus = sequential.test( token );

			if( status != PatternStatus.FAILURE )						// open? keep going! success? ...
				this.status = status;

			if( status == PatternStatus.SUCCESS )						// success, stop testing others
				break;
		}

		// ------------------------- //

		var result:PatternStatus = this.status;

		if( this.status != PatternStatus.OPEN )
			this.reset();

		return result;
	}

	// shallow copy
	public function clone():PatternListParallel
	{
		var clone:PatternListParallel = new PatternListParallel();
			clone.expressions = this.expressions;

		return clone;
	}

	//
	private function reset():Void
	{
		this.testing = null;
		this.status = PatternStatus.OPEN;
	}
}

/**
 *
 */
class PatternListSequential
{
	// open, success, failure
	public var status(default,null):PatternStatus;

	// ------------------ //

	// sequential -> reference
	public var expressions:Array<PatternReference>;

	// tmp clone of expressions
	public var testing:Array<PatternListSequential>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		this.status = PatternStatus.OPEN;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * any reference fail = fail for sequential
	 * any reference open = open for sequential
	 * all reference success = success for sequential
	 */
	public function test( token:TokenType ):PatternStatus
	{
		if( !this.status == PatternStatus.OPEN )
			throw "already completed pattern (status != open): sequence";

		// ------------------------- //
		// shallow copy for testing

		if( this.testing == null )
		{
			this.testing = new Array<PatternReference>();

			for( j in 0...this.expressions.length )
				this.testing[j] = this.expressions[j].clone();
		}

		// ------------------------- //
		// testing all references one by one

		this.status = PatternStatus.OPEN;

		for( k in 0...this.testing.length )
		{
			var reference:PatternReference = this.testing[k];

			if( reference.status == PatternStatus.SUCCESS )				// already checked
				continue;

			if( reference.status == PatternStatus.FAILURE )
				throw "sequence already failed yet checked again";

			var isLast:Bool = k == this.testing.length - 1;

			// --------------------- //

			var status:PatternStatus = reference.test( token );

			if( isLast )
			{
				if( status == PatternStatus.SUCCESS )					// all successfull?
					this.status = status;
			}

			if( status == PatternStatus.FAILURE )
				this.status = status;

			break;
		}

		// ------------------------- //

		var result:PatternStatus = this.status;

		if( this.status != PatternStatus.OPEN )
			this.reset();

		return result;
	}

	// shallow copy
	public function clone():PatternListSequential
	{
		var clone:PatternListSequential = new PatternListSequential();
			clone.expressions = this.expressions;

		return clone;
	}

	//
	private function reset():Void
	{
		this.testing = null;
		this.status = PatternStatus.OPEN;
	}
}