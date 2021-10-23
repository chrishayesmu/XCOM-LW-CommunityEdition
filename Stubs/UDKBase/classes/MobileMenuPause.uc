/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MobileMenuPause extends MobileMenuScene
	dependson(SimpleGame);

// A reference to the help screen that we will fade out as the player enters the game
var MobileMenuControls FadingControlsMenu;

var bool bHelpFadingOut;
var float HelpFadeTime;
var float HelpFadeDuration;

/** Holds how much of the menu is shown. */
var float ShownSize;

var float Scale;

var bool bFlashHelp;
var float FlashDuration;
var float FlashTime;

event InitMenuScene(MobilePlayerInput PlayerInput, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
	local int i;

	Super.InitMenuScene(PlayerInput, 960, 640, bIsFirstInitialization);

	Scale = (ScreenWidth >= 960) ? 1.0 : Float(ScreenWidth) / 960.0;
	for(i=1;i<MenuObjects.Length;i++)
	{
		MenuObjects[i].Left *= Scale;
		MenuObjects[i].Top *= Scale;
		MenuObjects[i].Width *= Scale;
		MenuObjects[i].Height *= Scale;
	}

	MenuObjects[0].Height *= Scale;
	MenuObjects[0].Width *= Scale;
	if (ScreenWidth == 1024)
	{
		MenuObjects[0].Width = 2048;
	}
	else if (ScreenWidth < 960)
	{
		MobileMenuImage(MenuObjects[0]).ImageDrawStyle=IDS_Stretched;
	}

	// Handle the main window

	Width = ScreenWidth;
	Height *= Scale;
	// Position the buttons..

	MenuObjects[1].Left = (ScreenWidth / 4) - (MenuObjects[2].Width/2);
	MenuObjects[2].Left = ScreenWidth - (ScreenWidth / 4) - (MenuObjects[2].Width/2);

	Top = -Height;
	ShownSize = Height - MenuObjects[1].Top + (8 * Scale);	// @ToDo Make the top border size config.
}

event OnTouch(MobileMenuObject Sender,float TouchX, float TouchY, bool bCancel)
{
	local CastlePC PC;

	if (Sender == none)
	{
		return;
	}

	if (bCancel == true)
	{
		return;
	}

	PC = CastlePC(InputOwner.Outer);

	if (Sender.Tag == "BIRDSEYE")
	{
		// start or stop the matinee
		if (PC.bIsInAttractMode)
		{
			PC.ExitAttractMode();
		}
		else
		{
			PC.EnterAttractMode();
		}
	}
	else if (Sender.Tag == "ABOUT")
	{
		InputOwner.Outer.ConsoleCommand("mobile about ue3-iphone");
	}
}

function OnResetMenu()
{
}


/**
 * When the submenu is open, force the freelook zone to have a full opaque inactive color so we
 * can see it in the input samples.
 */
function HackInactiveAlpha(float NewValue)
{
	local MobileInputZone Zone;
	Zone = MobilePlayerInput(CastlePC(InputOwner.Outer).PlayerInput).FindZone("FreeMoveZone");
	Zone.InactiveAlpha=NewValue;
}

function RenderScene(Canvas Canvas,float RenderDelta)
{
	if (InputOwner == none)
	{
		return;
	}
	// Set the right UVs
	if (CastlePC(InputOwner.Outer).bIsInAttractMode)
	{
		MobileMenuButton(MenuObjects[2]).ImagesUVs[0].U = 305;
		MobileMenuButton(MenuObjects[2]).ImagesUVs[0].V = 220;
		MobileMenuButton(MenuObjects[2]).ImagesUVs[1].U = 305;
		MobileMenuButton(MenuObjects[2]).ImagesUVs[1].V = 271;
	}
	else
	{
		MobileMenuButton(MenuObjects[2]).ImagesUVs[0].U = 128;
		MobileMenuButton(MenuObjects[2]).ImagesUVs[0].V = 615;
		MobileMenuButton(MenuObjects[2]).ImagesUVs[1].U = 128;
		MobileMenuButton(MenuObjects[2]).ImagesUVs[1].V = 672;
	}

	Super.RenderScene(Canvas, RenderDelta);
}

function bool OnSceneTouch(EZoneTouchEvent EventType, float X, float Y)
{
	local CastlePC PC;

	PC = CastlePC(InputOwner.Outer);
	if (PC.bPauseMenuOpen)
	{
		if (EventType != ZoneEvent_Cancelled)
		{
			PC.ResetMenu();

			return (PC.SliderZone != none &&
				( X >= PC.SliderZone.CurrentLocation.X && X < PC.SliderZone.CurrentLocation.X + PC.SliderZone.ActiveSizeX &&
				Y >= PC.SliderZone.CurrentLocation.Y && Y < PC.SliderZone.CurrentLocation.Y + PC.SliderZone.ActiveSizeY));
		}
		return true;
	}
	return false;
}

function FlashHelp(float Duration)
{
	bFlashHelp = true;
	FlashDuration = Duration;
	FlashTime = 0;
	bHelpFadingOut = false;
	HelpFadeTime = 0;
}

function ReleaseHelp()
{
	if (bFlashHelp)
	{
		bFlashHelp = false;
		bHelpFadingOut = true;
		HelpFadeTime = HelpFadeDuration;
		HelpFadeTime = HelpFadeDuration - HelpFadeTime;
	}
}

defaultproperties
{
	SceneCaptionFont=MultiFont'CastleFonts.Positec'
	Left=0
	Top=0
	Width=1.0
	bRelativeLeft=true
	bRelativeWidth=true
	Height=180;

	Begin Object Class=MobileMenuImage Name=Background
		Tag="Background"
		Left=0
		Top=0
		Width=1.0
		Height=1.0
		bRelativeWidth=true
		bRelativeHeight=true
		Image=Texture2D'CastleUI.menus.T_CastleMenu2'
		ImageDrawStyle=IDS_Tile
		ImageUVs=(bCustomCoords=true,U=0,V=30,UL=1024,VL=180)
	End Object
	MenuObjects(0)=Background

	Begin Object Class=MobileMenuButton Name=AboutButton
		Tag="ABOUT"
		Left=0
		Top=-85
		Width=281
		Height=48
		TopLeeway=20
		Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
		Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
		ImagesUVs(0)=(bCustomCoords=true,U=354,V=562,UL=310,VL=48)
		ImagesUVs(1)=(bCustomCoords=true,U=676,V=562,UL=310,VL=48)
	End Object
	MenuObjects(1)=AboutButton

	Begin Object Class=MobileMenuButton Name=AttractButton
		Tag="BIRDSEYE"
		Left=0
		Top=-85
		Width=310
		Height=48
		TopLeeway=20
		Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
		Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
		ImagesUVs(0)=(bCustomCoords=true,U=305,V=220,UL=310,VL=48)
		ImagesUVs(1)=(bCustomCoords=true,U=305,V=271,UL=310,VL=48)
	End Object
	MenuObjects(2)=AttractButton

	UITouchSound=SoundCue'CastleAudio.UI.UI_ChangeSelection_Cue'
	UIUnTouchSound=SoundCue'CastleAudio.UI.UI_ChangeSelection_Cue'
	HelpFadeDuration=0.3
}

