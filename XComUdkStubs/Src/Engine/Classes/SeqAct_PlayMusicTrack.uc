/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_PlayMusicTrack extends SequenceAction
	native(Sequence)
	dependson(MusicTrackDataStructures);


var() MusicTrackStruct MusicTrack;

cpptext
{
	virtual void Activated();
	virtual void PreSave();
}


defaultproperties
{
	ObjName="Play Music Track"
	ObjCategory="Sound"

	VariableLinks.Empty
}