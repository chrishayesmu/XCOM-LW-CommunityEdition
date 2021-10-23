/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class MobileHUDExt extends MobileHUD;

struct CachedLastTouch
{
	// FakeMenu
	var bool bTouchEventPending;
	var float X;
	var float Y;
};

/** Texture to use for 'tap-to-move' screen space effect */
var Texture2D TapToMoveTexture;

/** Last time that we were asked to draw the tap to move effect */
var float LastTapToMoveEffectTime;
var Vector2D TapToMoveEffectPos;

/** We process the events in MobileHUD */
var CachedLastTouch LastTouch;

var bool bFlashJoysticks;
var float FlashTime;

/** Starts drawing a transparent circle at the specified location for a brief moment (with animation) */
function StartTapToMoveEffect( float X, float Y )
{
	// Store time that we were asked to draw the effect.  This effectively "turns on" the effect.
	LastTapToMoveEffectTime = WorldInfo.RealTimeSeconds;
	TapToMoveEffectPos.X = X;
	TapToMoveEffectPos.Y = Y;
}


/** Draws the tap to move effect if we need to */
function ConditionallyDrawTapToMoveEffect()
{
	local float EffectDuration;
	local float EffectSize;
	local float EffectOpacity;
	local float FadeInPercent;
	local float FadeOutPercent;

	local float EffectProgress;
	local float AnimatedSize;
	local float AnimatedOpacity;

	// How long the effect should last
	EffectDuration = 0.25;
	FadeInPercent = 0.1;
	FadeOutPercent = 0.6;

	// How big the effect should be
	EffectSize = 64.0;

	// Maximum opacity of the effect
	EffectOpacity = 0.3;

	// Is it time to draw the effect?
	if( WorldInfo.RealTimeSeconds - LastTapToMoveEffectTime < EffectDuration )
	{
		EffectProgress = FClamp( ( WorldInfo.RealTimeSeconds - LastTapToMoveEffectTime ) / EffectDuration, 0.0, 1.0 );
		EffectProgress = FInterpEaseIn( 0.0, 1.0, EffectProgress, 1.5 );

		AnimatedSize = EffectSize * 0.15 + EffectSize * EffectProgress * 0.85;
		
		AnimatedOpacity = EffectOpacity;

		// Fade in over the first bit of the effect
		if( EffectProgress < FadeInPercent )
		{
			AnimatedOpacity *= ( EffectProgress / FadeInPercent );
		}

		// Fade out over the tail end of the effect
		if( EffectProgress > ( 1.0 - FadeOutPercent ) )
		{
			AnimatedOpacity *= 1.0 - ( EffectProgress - ( 1.0 - FadeOutPercent ) ) / FadeOutPercent;
		}


		Canvas.SetPos( TapToMoveEffectPos.X - AnimatedSize * 0.5, TapToMoveEffectPos.Y - AnimatedSize * 0.5 );
 		Canvas.SetDrawColor( 255, 255, 255, AnimatedOpacity * 255.0 );
		Canvas.DrawTile( TapToMoveTexture, AnimatedSize, AnimatedSize, 0.0, 0.0, TapToMoveTexture.GetSurfaceWidth(), TapToMoveTexture.GetSurfaceHeight() );
	}
}

function bool ShowMobileHud()
{
	// Show the mobile HUD if we are allowed to and if we don't have the HUD disabled via cinematic mode.
	return bShowMobileHud && bShowHud;
}

function PostRender()
{
	local CastlePC PC;
	local float Scale,w,h;

	Instigator = PlayerOwner.Pawn;

	super.PostRender();	

	PC = CastlePC(PlayerOwner);


	if (PC.bIsInAttractMode)
	{
		Scale = Canvas.ClipX / 960;
		w = 124 * scale;
		h = w * 1.193548387096774;
		Canvas.SetPos(Canvas.ClipX - 192*Scale, Canvas.ClipY - 171*Scale);
		Canvas.DrawColor = WhiteColor;
		Canvas.DrawTile(Texture2D'CastleUI.menus.T_CastleMenu2',w,h,0,759,124,148);
	}

	if ( bShowHud && !PC.bIsInAttractMode)
		return;

	
	// Draw the tap to move HUD animation, if we need to
	ConditionallyDrawTapToMoveEffect();

}

function DrawMobileZone_Slider(MobileInputZone Zone)
{
	local TextureUVs UVs;
	local Texture2D Tex;
	local float Ofs,Scale;

	// First, look up the Texture

	Tex = SliderImages[int(Zone.SlideType)];
	UVs = SliderUVs[int(Zone.SlideType)];

	// Now, figure out where we have to draw.


	Scale = CastlePC(PlayerOwner).PauseMenu.Scale;
	Ofs = 16 *Scale;

	Canvas.SetPos(Zone.CurrentLocation.X, Zone.CurrentLocation.Y-Ofs);
	Canvas.DrawTile(Tex,Zone.ActiveSizeX, Zone.ActiveSizeY, UVs.U, UVs.V, UVs.UL, UVs.VL);
}

function DrawMobileZone_Joystick(MobileInputZone Zone)
{
	local int X, Y, Width, Height;
	local Color LineColor;
	local float ClampedX, ClampedY, Scale;
	local Color TempColor;
	local float FlashScale;


	if (bFlashJoysticks)
	{
		FlashScale = FInterpEaseOut(3.0,1.0,FlashTime/0.75,2);
		FlashTime += RenderDelta;
		if (FlashTime > 0.75)
		{
			bFlashJoysticks = false;
		}
	}
	else
	{
		FlashScale = 1.0;
	}

	if (JoystickBackground != none)
	{
		Width = Zone.ActiveSizeX * FlashScale;
		Height = Zone.ActiveSizeY * FlashScale;

		X = Zone.CurrentCenter.X - (Width /2);
		Y = Zone.CurrentCenter.Y - (Height /2);

		Canvas.SetPos(X,Y);
		Canvas.DrawTile(JoystickBackground, Width, Height, JoystickBackgroundUVs.U, JoystickBackgroundUVs.V, JoystickBackgroundUVs.UL, JoystickBackgroundUVs.VL);
	}

	// Draw the Hat

	if (JoystickHat != none)
	{
		// Compute X and Y clamped to the size of the zone for the joystick
		ClampedX = Zone.CurrentLocation.X - Zone.CurrentCenter.X;
		ClampedY = Zone.CurrentLocation.Y - Zone.CurrentCenter.Y;
		Scale = 1.0f;
		if ( ClampedX != 0 || ClampedY != 0 )
		{
			Scale = Min( Zone.ActiveSizeX, Zone.ActiveSizeY ) / ( 2.0 * Sqrt(ClampedX * ClampedX + ClampedY * ClampedY) );
			Scale = FMin( 1.0, Scale );
		}
		ClampedX = ClampedX * Scale + Zone.CurrentCenter.X;
		ClampedY = ClampedY * Scale + Zone.CurrentCenter.Y;

		if (Zone.bRenderGuides)
		{
			TempColor = Canvas.DrawColor;
			LineColor.R = 128;
			LineColor.G = 128;
			LineColor.B = 128;
			LineColor.A = 255;
			Canvas.Draw2DLine(Zone.CurrentCenter.X, Zone.CurrentCenter.Y, ClampedX, ClampedY, LineColor);
			Canvas.DrawColor = TempColor;

		}

		// The size of the indicator will be a fraction of the background's total size
		Width = Zone.ActiveSizeX * 0.65 * FlashScale;
		Height = Zone.ActiveSizeY * 0.65 * FlashScale;

		Canvas.SetPos( ClampedX - Width / 2, ClampedY - Height / 2);
		Canvas.DrawTile(JoystickHat, Width, Height, JoystickHatUVs.U, JoystickHatUVs.V, JoystickHatUVs.UL, JoystickHatUVs.VL);
	}
}

function FlashSticks()
{
	bFlashJoysticks = true;
	FlashTime = 0;
}


defaultproperties
{
	JoystickBackground=Texture2D'MobileResources.T_MobileControls_texture'
	JoystickBackgroundUVs=(U=0,V=0,UL=126,VL=126)
	JoystickHat=Texture2D'MobileResources.T_MobileControls_texture'
	JoystickHatUVs=(U=128,V=0,UL=78,VL=78)

	ButtonImages(0)=Texture2D'MobileResources.HUD.MobileHUDButton3'
	ButtonImages(1)=Texture2D'MobileResources.HUD.MobileHUDButton3'
	ButtonUVs(0)=(U=0,V=0,UL=32,VL=32)
	ButtonUVs(1)=(U=0,V=0,UL=32,VL=32)

	TrackballBackground=none
	TrackballTouchIndicator=Texture2D'MobileResources.T_MobileControls_texture'
	TrackballTouchIndicatorUVs=(U=160,V=0,UL=92,VL=92)

	ButtonFont = Font'EngineFonts.SmallFont'
	ButtonCaptionColor=(R=0,G=0,B=0,A=255);

	SliderImages(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
	SliderImages(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
	SliderImages(2)=Texture2D'CastleUI.menus.T_CastleMenu2'
	SliderImages(3)=Texture2D'CastleUI.menus.T_CastleMenu2'
	SliderUVs(0)=(U=641,V=220,UL=161,VL=75)
	SliderUVs(1)=(U=641,V=220,UL=161,VL=75)
	SliderUVs(2)=(U=641,V=220,UL=161,VL=75)
	SliderUVs(3)=(U=641,V=220,UL=161,VL=75)

	LastTapToMoveEffectTime=-99999.0

	TapToMoveTexture=Texture2D'CastleHUD.HUD_TouchToMove'
 }