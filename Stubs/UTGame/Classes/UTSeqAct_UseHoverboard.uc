/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class UTSeqAct_UseHoverboard extends SequenceAction;

/** reference to the hoverboard that was spawned, so that the scripter can access it */
var UTVehicle Hoverboard;

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Use Hoverboard"
	ObjCategory="Pawn"

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Hoverboard",bWriteable=true,PropertyName=Hoverboard)
}
