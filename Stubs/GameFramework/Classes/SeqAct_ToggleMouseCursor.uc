/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * To use the existing OS mouse cursor, set bUseHardwareCursorWhenWindowed=TRUE in the [Engine.GameViewportClient] section of your engine.ini
 * To use the mobile input kismet actions with the mouse, set bFakeMobileTouches=true in the [GameFramework.MobilePlayerInput] section of your game.ini
 */
class SeqAct_ToggleMouseCursor extends SequenceAction;

defaultproperties
{
	ObjName="Toggle Mouse Cursor"
	ObjCategory="Input"

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")

}