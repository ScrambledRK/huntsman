package at.dotpoint.huntsman.analyser.parser.source.pattern;

import at.dotpoint.huntsman.analyser.parser.source.token.TokenProvider;
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

	//
	public var model(default,null):SourceDOM;

	// ------------------ //

	// parallel -> sequential -> reference
	public var expressions:PatternListParallel;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String )
	{
		this.name = name;

		this.cardinality = PatternCardinality.ONE;
		this.expressions = expressions;
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
	 * optional failed match -> failed, but test same token again with next pattern
	 * recurring success match -> success and token consumed, but test the same pattern again
	 */
	public function test( provider:TokenProvider ):PatternStatus
	{
		this.model.openPattern( this );

		// ---------------------------- //

		var status:PatternStatus = new PatternStatus();

		if( provider.currentToken() != null )								// is there a token to test?
		{
			var isSuccess:Bool 	= false;

			if( this.isTokenReference() )									// leaf node, decide!
			{
				isSuccess = this.name == provider.currentType().name;

				if( isSuccess )
					this.model.saveToken( provider.currentToken() );
			}
			else
			{
				isSuccess = this.expressions.test( provider );				// some pattern matched the tokens?
			}

			// ------------------------- //

			if( this.isOptional() && !isSuccess )	status.isConsumed = false;		// optional fail? go on ...
			else									status.isConsumed = true;

			if( this.isRecurring() && isSuccess )	status.isOpen = true;			// multiple times? check again
			else									status.isOpen = false;

			status.isSuccess = isSuccess;
		}
		else
		{
			status.isSuccess 	= false;
			status.isOpen 		= false;
			status.isConsumed 	= false;
		}

		// ------------------------- //

		this.model.closePattern( this );

		return status;
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
 * OR - Node; Testing ALL patterns in the least; once a pattern matches successfully
 * it returns successful.
 */
class PatternListParallel
{

	// sequential -> reference
	public var expressions:Array<PatternListSequential>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?expressions:Array<PatternListSequential> )
	{
		this.expressions = expressions;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * all sequential patterns fail = fail for parallel
	 * some sequential pattern success = success for parallel
	 */
	public function test( provider:TokenProvider ):Bool
	{
		var isSuccess:Bool = false;

		for( sequential in this.expressions )
		{
			var isSuccess:Bool = sequential.test( provider.clone() );

			if( isSuccess )
				break;
		}

		// ---------- //

		return isSuccess;
	}

}

/**
 *
 */
class PatternListSequential
{

	// sequential -> reference
	public var expressions:Array<PatternReference>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?expressions:Array<PatternListSequential> )
	{
		this.expressions = expressions;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * any mandatory reference fail = fail for sequential
	 * all reference success = success for sequential
	 */
	public function test( provider:TokenProvider ):Bool
	{
		for( reference in this.expressions )
		{
			var status:PatternStatus = null;
			var currentSuccess:Bool = false;

			do
			{
				status = reference.test( provider );

				if( status.isConsumed )
				{
					if( provider.hasNext() )	provider.nextType();		// consume token ...
					else						return false;				// ... or fail if reached end
				}

				if( status.isSuccess )
					currentSuccess = true;									// once true, always true
			}
			while( status.isOpen );											// recurring, continue token consumtion

			// -------- //

			if( !reference.isOptional() && !currentSuccess )
				return false;
		}

		// ------------ //

		return true;
	}

}