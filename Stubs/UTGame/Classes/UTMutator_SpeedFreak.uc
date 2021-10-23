// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
class UTMutator_SpeedFreak extends UTMutator;

/** Game speed modifier. */
var()	float	GameSpeed;

function InitMutator(string Options, out string ErrorMessage)
{
	WorldInfo.Game.SetGameSpeed(GameSpeed);
	Super.InitMutator(Options, ErrorMessage);
}

defaultproperties
{
	GroupNames[0]="GAMESPEED"
	GameSpeed=1.35
}
