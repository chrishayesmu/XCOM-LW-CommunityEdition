/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// GenericBrowserType_PhysicalMaterial: Physical properties of a material
//=============================================================================

class GenericBrowserType_PhysicalMaterial
	extends GenericBrowserType
	native;

cpptext
{
	virtual void Init();
	virtual UBOOL ShowObjectEditor( UObject* InObject );
}
	
defaultproperties
{
	Description="Physical Materials"
}
