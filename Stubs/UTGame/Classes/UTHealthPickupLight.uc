/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UTHealthPickupLight extends Light
	placeable;

defaultproperties
{
	DrawScale=0.25

		Begin Object Class=PointLightComponent Name=PointLightComponent0
	    LightAffectsClassification=LAC_STATIC_AFFECTING
		CastShadows=TRUE
		CastStaticShadows=TRUE
		CastDynamicShadows=FALSE
		bForceDynamicLight=FALSE
		UseDirectLightMap=TRUE
		LightingChannels=(BSP=TRUE,Static=TRUE,Dynamic=FALSE,bInitialized=TRUE)
		Brightness=4
		LightColor=(R=201,G=250,B=225)
		Radius=128
	End Object
	LightComponent=PointLightComponent0
	Components.Add(PointLightComponent0)
}
