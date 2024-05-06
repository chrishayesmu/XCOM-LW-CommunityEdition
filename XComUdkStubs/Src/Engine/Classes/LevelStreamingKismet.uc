/**
 * LevelStreamingKismet
 *
 * Kismet triggerable streaming implementation.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class LevelStreamingKismet extends LevelStreaming
	native;

cpptext
{
	/**
	 * Returns whether this level should be present in memory which in turn tells the 
	 * streaming code to stream it in. Please note that a change in value from FALSE 
	 * to TRUE only tells the streaming code that it needs to START streaming it in 
	 * so the code needs to return TRUE an appropriate amount of time before it is 
	 * needed.
	 *
	 * @param ViewLocation	Location of the viewer
	 * @return TRUE if level should be loaded/ streamed in, FALSE otherwise
	 */
	virtual UBOOL ShouldBeLoaded( const FVector& ViewLocation );

	/**
	 * Returns whether this level should be visible/ associated with the world if it is
	 * loaded.
	 * 
	 * @param ViewLocation	Location of the viewer
	 * @return TRUE if the level should be visible, FALSE otherwise
	 */
	virtual UBOOL ShouldBeVisible( const FVector& ViewLocation );
}
