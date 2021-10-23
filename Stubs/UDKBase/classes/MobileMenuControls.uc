/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MobileMenuControls extends MobileMenuScene;

var float FadeTime, FadeDuration;
var float AnimTime;
var bool bFadeOut;

var bool bAnimate;
var MobileMenuImage Icon;
var MobileMenuImage Msg;
var float Scale;

function FadeOut()
{
	FadeTime = 0;
	FadeDuration = 0.5;
	bFadeOut = true;
}

function Setup(bool bTap)
{

	Icon = MobileMenuImage(MenuObjects[0]);
	Msg = MobileMenuImage(MenuObjects[1]);

	Scale = Width / 960;

	FadeTime = 0;
	FadeDuration = 0.5;
	bFadeOut = false;

	if (bTap)
	{	
		bAnimate = true;
		Icon.Width = 84 * Scale;
		Icon.Height = 84 * Scale;
		Icon.Left = (Width * 0.5) - (Icon.Width * 0.5);
		Icon.Top = Height * 0.50;
		Icon.ImageUVs.U  = 653;
		Icon.ImageUVs.V  = 317;
		Icon.ImageUVs.UL = 84;
		Icon.ImageUVs.VL = 84;

		Msg.Width = 373 * Scale;
		Msg.Height = 59 * Scale;
		Msg.Left = Width * 0.5 - Msg.Width * 0.5;
		Msg.Top = Height - Msg.Height * 2;
		Msg.ImageUVs.U = 538;
		Msg.ImageUVs.V = 918;
		Msg.ImageUVs.UL = 373;
		Msg.ImageUVs.VL = 59;
	}
	else
	{
		bAnimate = false;
		Icon.Width = 586 * Scale;
		Icon.Height = 133 * Scale;
		Icon.Left = (Width * 0.5) - (Icon.Width * 0.5);
		Icon.Top = Height * 0.25;
		Icon.ImageUVs.U  = 246; 
		Icon.ImageUVs.V  = 428;
		Icon.ImageUVs.UL = 586;
		Icon.ImageUVs.VL = 133;

		Msg.Width = 373 * Scale;
		Msg.Height = 59 * Scale;
		Msg.Left = (Width * 0.5) - (Msg.Width * 0.5);
		Msg.Top = Height - (Msg.Height * 2);
		Msg.ImageUVs.U = 128;
		Msg.ImageUVs.V = 918;
		Msg.ImageUVs.UL = 373;
		Msg.ImageUVs.VL = 59;
	}
}

function RenderScene(Canvas Canvas,float RenderDelta)
{
	local float alpha;
	if (bAnimate)
	{
		Alpha = 1 - AnimTime/0.75;
		AnimTime += RenderDelta;
		if (AnimTime > 0.75)
		{
			AnimTime = 0;
		}

		Icon.Width = 84 * Scale * (1 + 1-Alpha);
		Icon.Height = 84 * Scale * (1 + 1-Alpha);
		Icon.Left = (Width * 0.5) - (Icon.Width * 0.5);
		Icon.Top = Height * 0.50 - (Icon.Height * 0.5);
		Icon.Opacity = Alpha;
	}

	if (FadeDuration > 0)
	{
		Opacity = bFadeOut ? FInterpEaseIn(1,0,FadeTime/FadeDuration,2.0) : FInterpEaseOut(0,1,FadeTime/FadeDuration,2.0);
		FadeTime += RenderDelta;

		if (FadeTime > FadeDuration)
		{
			FadeDuration = 0;
			if (bFadeOut)
			{
				InputOwner.CloseMenuScene(self);
			}
		}
	}

	Super.RenderScene(Canvas,RenderDelta);
}


defaultproperties
{
	Left=0
	Top=0
	Width=1.0
	Height=1.0
	bRelativeLeft=true
	bRelativeTop=true
	bRelativeWidth=true
	bRelativeHeight=true

	Begin Object Class=MobileMenuImage Name=Icon
		Tag="Background"
		Left=0
		Top=0
		Width=1
		Height=1
		bRelativeWidth=true
		bRelativeHeight=true
		Image=Texture2D'CastleUI.menus.T_CastleMenu2'
		ImageDrawStyle=IDS_Stretched
		ImageUVs=(bCustomCoords=true,U=0,V=0,UL=960,VL=640)
		bIsActive=false
	End Object
	MenuObjects(0)=Icon

	Begin Object Class=MobileMenuImage Name=Msg
		Tag="Background"
		Left=0
		Top=0
		Width=1
		Height=1
		bRelativeWidth=true
		bRelativeHeight=true
		Image=Texture2D'CastleUI.menus.T_CastleMenu2'
		ImageDrawStyle=IDS_Stretched
		ImageUVs=(bCustomCoords=true,U=0,V=0,UL=960,VL=640)
		bIsActive=false
	End Object
	MenuObjects(1)=Msg
	bSceneDoesNotRequireInput=true
	Opacity=0
}