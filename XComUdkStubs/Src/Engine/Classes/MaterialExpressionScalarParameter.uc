/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MaterialExpressionScalarParameter extends MaterialExpressionParameter
	native(Material)
	collapsecategories
	hidecategories(Object);

var() float	DefaultValue;

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Parameters"
}
