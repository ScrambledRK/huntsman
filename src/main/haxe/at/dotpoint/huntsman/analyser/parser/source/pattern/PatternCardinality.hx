package at.dotpoint.huntsman.analyser.parser.source.pattern;

/**
 * 22.04.2016
 * @author RK
 */
enum PatternCardinality
{
	ONE;		// default
	ZERO_ONE;	// ?
	ZERO_N;		// *
	ONE_N;		// +
}