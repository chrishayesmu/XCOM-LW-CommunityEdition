/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UDKTeamPlayerStart extends PlayerStart
	native;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void Spawned();
}

// Players on different teams are not spawned in areas with the
// same TeamNumber unless there are more teams in the level than
// team numbers.
var() byte TeamNumber;			// what team can spawn at this start

// sprites used for this actor in the editor, depending on which team it's on
var editoronly array<Texture2D> TeamSprites;

