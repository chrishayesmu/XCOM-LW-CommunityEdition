/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MaterialExpressionDestDepth extends MaterialExpression
	native(Material)
	collapsecategories
	hidecategories(Object);

/** 
 * MaterialExpressionDestDepth: 
 * Gives the depth value at the current screen position destination
 * for use in a material
 */

/** normalize the depth values to [near,far] -> [0,1] */
var() bool bNormalize;

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Destination"
	MenuCategories(1)="Depth"
	Outputs(0)=(OutputName="",Mask=1,MaskR=1,MaskG=0,MaskB=0,MaskA=0)
}
