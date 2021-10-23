/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UTEmit_HitEffect extends UTEmitter;

simulated function AttachTo(Pawn P, name NewBoneName)
{
	if (NewBoneName == '')
	{
		SetBase(P);
	}
	else
	{
		SetBase(P,, P.Mesh, NewBoneName);
	}
}

simulated function PawnBaseDied()
{
	if (ParticleSystemComponent != None)
	{
		ParticleSystemComponent.DeactivateSystem();
	}
}

defaultproperties
{
}
