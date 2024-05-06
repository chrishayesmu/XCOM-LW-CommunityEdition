/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class WallTransReachSpec extends ForcedReachSpec
	native;

cpptext
{
	virtual INT CostFor(APawn* P);
}

defaultproperties
{
	bSkipPrune=TRUE
}
