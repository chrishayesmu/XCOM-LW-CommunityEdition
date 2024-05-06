/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InstancedFoliageSettings extends Object
	native(Foliage)
	hidecategories(Object)
	editinlinenew;

var(Painting) float Density;
var(Painting) float Radius;
var(Painting) float ScaleMinX;
var(Painting) float ScaleMinY;
var(Painting) float ScaleMinZ;
var(Painting) float ScaleMaxX;
var(Painting) float ScaleMaxY;
var(Painting) float ScaleMaxZ;
var(Painting) float AlignMaxAngle;
var(Painting) float RandomPitchAngle;
var(Painting) float GroundSlope;
var(Painting) float HeightMin;
var(Painting) float HeightMax;
var(Painting) Name LandscapeLayer;
var(Painting) bool AlignToNormal;
var(Painting) bool RandomYaw;
var(Painting) bool UniformScale;

var(Clustering) int MaxInstancesPerCluster;
var(Clustering) float MaxClusterRadius;


enum FoliageCullOption
{
	FOLIAGECULL_Cull,
	FOLIAGECULL_ScaleZ,
	FOLIAGECULL_ScaleXYZ,
	FOLIAGECULL_TranslateZ
};

var(Culling) int StartCullDistance;
var(Culling) int EndCullDistance;
var(Culling) FoliageCullOption CullOption;

var int DisplayOrder;
var bool IsSelected;
var bool bShowNothing;
var bool bShowPaintSettings;
var bool bShowInstanceSettings;

defaultproperties
{
	Density=100.0
	Radius=64.0
	AlignToNormal=true
	RandomYaw=true
	UniformScale=true
	ScaleMinX=1.0
	ScaleMinY=1.0
	ScaleMinZ=1.0
	ScaleMaxX=1.0
	ScaleMaxY=1.0
	ScaleMaxZ=1.0
	AlignMaxAngle=0.0
	RandomPitchAngle=0.0
	GroundSlope=45.0
	HeightMin=-262144.0
	HeightMax=262144.0
	LandscapeLayer=None
	MaxInstancesPerCluster=100
	MaxClusterRadius=10000.0
	DisplayOrder=0
	IsSelected=false
	bShowNothing=true
	bShowPaintSettings=false
	bShowInstanceSettings=false
}
