/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UTDmgType_Lava extends UTDmgType_Burning
	abstract;

defaultproperties
{
	DamageBodyMatColor=(R=50,G=50)
	DamageOverlayTime=0.3
	DeathOverlayTime=0.6
	bUseTearOffMomentum=false
	bCausedByWorld=true
}
