/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MaterialExpressionTextureSampleParameter2D extends MaterialExpressionTextureSampleParameter
	native(Material)
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual FString GetCaption() const;
	virtual UBOOL TextureIsValid( UTexture* InTexture );
	virtual const TCHAR* GetRequirements();
	
	/**
	 *	Sets the default texture if none is set
	 */
	virtual void SetDefaultTexture();
}

defaultproperties
{
	Texture=Texture2D'EngineResources.DefaultTexture'
	MenuCategories(0)="Texture"
	MenuCategories(1)="Parameters"
}
