/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InterpTrackInstFade extends InterpTrackInst
	native(Interpolation);


cpptext
{
	// InterpTrackInst interface
	virtual void TermTrackInst(UInterpTrack* Track);
}
