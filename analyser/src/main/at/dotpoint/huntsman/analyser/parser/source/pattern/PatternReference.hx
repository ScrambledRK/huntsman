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
	public var cardinality:PatternCardinality;

	// ------------------ //

	// parallel -> sequential -> reference
	public var expressions:PatternListParallel;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String, ?isTokenReference:Bool = false )
	{
		this.name = name;

		this.cardinality = PatternCardinality.ONE;
		this.expressions = isTokenReference ? null : new PatternListParallel();
	}

	public function clone():PatternReference
	{
		var clone:PatternReference = new PatternReference( this.name );
			clone.cardinality = this.cardinality;
			clone.expressions = this.expressions;

		return clone;
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
	public function test( provider:TokenProvider, model:SourceDOM ):PatternStatus
	{
		model.openPattern( this, provider.currentToken(), provider.index );

		// ---------------------------- //

		var status:PatternStatus = new PatternStatus();

		if( provider.currentToken() != null )								// is there a token to test?
		{
			var isSuccess:Bool 	= false;

			if( this.isTokenReference() )									// leaf node, decide!
			{
				isSuccess = this.name == provider.currentType().name;

				if( isSuccess )
					model.saveToken( provider.currentToken() );
			}
			else
			{
				isSuccess = this.expressions.test( provider, model );				// some pattern matched the tokens?
			}

			// ------------------------- //

			if( this.isOptional() && !isSuccess )	status.isConsumed = false;		// optional fail? go on ...
			else									status.isConsumed = isSuccess;

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

		model.closePattern( this, status );

		return status;
	}

	// ************************************************************************ //
	// toString
	// ************************************************************************ //

	//
	public function toString():String
	{
		return "[" + this.name + this.getCardinalityString() + "]";
	}

	/**
	 *
	 */
	private function getCardinalityString():String
	{
		switch( this.cardinality )
		{
			case PatternCardinality.ZERO_ONE: 	return "?";
			case PatternCardinality.ZERO_N: 	return "*";
			case PatternCardinality.ONE_N: 		return "+";

			default:
				return "";
		}
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

	public function new()
	{
		this.expressions = new Array<PatternListSequential>();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * all sequential patterns fail = fail for parallel
	 * some sequential pattern success = success for parallel
	 */
	public function test( provider:TokenProvider, model:SourceDOM ):Bool
	{
		for( sequential in this.expressions )
		{
			var isSuccess:Bool = sequential.test( provider, model );

			if( isSuccess )
				return true;
		}

		// ---------- //

		return false;
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

	public function new()
	{
		this.expressions = new Array<PatternReference>();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * any mandatory reference fail = fail for sequential
	 * all reference success = success for sequential
	 */
	public function test( provider:TokenProvider, model:SourceDOM ):Bool
	{
		for( reference in this.expressions )
		{
			var status:PatternStatus = null;
			var currentSuccess:Bool = false;

			do
			{
				status = reference.test( provider, model );

				if( reference.isTokenReference() && status.isConsumed )		// only token test can consume tokens
					provider.nextType();

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