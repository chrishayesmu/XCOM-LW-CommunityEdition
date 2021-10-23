/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class FractureMaterial extends Object
	native(Physics)
	collapsecategories
	hidecategories(Object);

/** Particle system effect to play at fracture location. */
var()	ParticleSystem				FractureEffect;
/** Sound cue to play at fracture location. */
var()	SoundCue					FractureSound;

defaultproperties
{
}
