/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MobileMenuSplash extends MobileMenuScene;

var float HelpFlashDuration;

event InitMenuScene(MobilePlayerInput PlayerInput, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
	local float scale;

	if (ScreenWidth < 960)
	{
		MenuObjects[0].Width = 0.95;
	}

	super.InitMenuScene(PlayerInput, ScreenWidth, ScreenHeight, bIsFirstInitialization);

	Scale = (ScreenWidth >= 960) ? 1.0 : Float(ScreenWidth) / 960;

	MenuObjects[1].Width = 574 * Scale;
	MenuObjects[1].Height = 574 * Scale * 0.1393728222996516;
	MenuObjects[1].Left = (ScreenWidth/2) - 40*Scale;

}

event OnTouch(MobileMenuObject Sender,float TouchX, float TouchY, bool bCancel)
{
	local CastlePC PC;
	if (Sender.Tag == "CATCHALL")
	{
		if (bCancel == false)
		{
			PC = CastlePC(InputOwner.Outer);
			InputOwner.CloseMenuScene(self);
			PC.FlashHelp(HelpFlashDuration);
		}
	}
}

function Closed() 
{
	CastlePC(InputOwner.Outer).StartTutorials();
	Super.Closed();
}

defaultproperties
{

	Top=0
	Left=0
	Width=1.0
	Height=1.0
	bRelativeWidth=true
	bRelativeHeight=true

	Begin Object Class=MobileMenuImage Name=INFO
		Tag="INFO"
		Left=0.5
		Top=0.5
		Width=0.6927083
		Height=0.2601503759398496
		bHeightRelativeToWidth=true
		XOffset=0.5
		YOffset=0.5
		bRelativeLeft=true
		bRelativeTop=true
		bRelativeWidth=true
		bRelativeHeight=true
		Image=Texture2D'CastleUI.menus.T_CastleMenu2'
		ImageDrawStyle=IDS_Stretched
		ImageUVs=(bCustomCoords=true,U=132,V=734,UL=665,VL=173)
	End Object
	MenuObjects(0)=INFO

	Begin Object Class=MobileMenuImage Name=Highlight
		Tag="HIGHLIGHT"
		Left=0
		Top=0
		Width=587
		Height=84
		Image=Texture2D'CastleUI.menus.T_CastleMenu2'
		ImageDrawStyle=IDS_Stretched
		ImageUVs=(bCustomCoords=true,U=449,V=614,UL=574,VL=80)
	End Object
	MenuObjects(1)=Highlight

	Begin Object Class=MobileMenuButton Name=CATCHALL
		Tag="CATCHALL"
		Left=0
		Top=0
		Width=1
		Height=1
		bRelativeLeft=true
		bRelativeTop=true
		bRelativeWidth=true
		bRelativeHeight=true
		bIsActive=true;
	End Object
	MenuObjects(2)=CATCHALL

	HelpFlashDuration=2
}
