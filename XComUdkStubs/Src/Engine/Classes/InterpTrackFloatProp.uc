class InterpTrackFloatProp extends InterpTrackFloatBase
	native(Interpolation);

/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

cpptext
{
	// InterpTrack interface
	virtual INT AddKeyframe(FLOAT Time, UInterpTrackInst* TrInst, EInterpCurveMode InitInterpMode);
	virtual void UpdateKeyframe(INT KeyIndex, UInterpTrackInst* TrInst);
	virtual void PreviewUpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst);
	virtual void UpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst, UBOOL bJump);
	
	/** Get the name of the class used to help out when adding tracks, keys, etc. in UnrealEd.
	* @return	String name of the helper class.*/
	virtual const FString	GetEdHelperClassName() const;

	virtual class UMaterial* GetTrackIcon() const;

	/** 
	 * Reduce Keys within Tolerance
	 *
	 * @param bIntervalStart	start of the key to reduce
	 * @param bIntervalEnd		end of the key to reduce
	 * @param Tolerance			tolerance
	 */
	virtual void ReduceKeys( FLOAT IntervalStart, FLOAT IntervalEnd, FLOAT Tolerance );
}

/** Name of property in Group Actor which this track mill modify over time. */
var()	editconst	name		PropertyName;

defaultproperties
{
	TrackInstClass=class'Engine.InterpTrackInstFloatProp'
	TrackTitle="Float Property"
}
