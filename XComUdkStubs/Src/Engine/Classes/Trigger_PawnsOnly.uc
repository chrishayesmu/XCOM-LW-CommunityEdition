/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Trigger_PawnsOnly extends Trigger
	native;

cpptext
{
	virtual UBOOL ShouldTrace( UPrimitiveComponent* Primitive,AActor *SourceActor, DWORD TraceFlags );
};

defaultproperties
{
}