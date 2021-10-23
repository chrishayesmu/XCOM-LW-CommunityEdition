class LandscapeMaterialInstanceConstant extends MaterialInstanceConstant
	native(Terrain);

var bool bIsLayerThumbnail;

cpptext
{
	/**
	* Custom version of AllocateResource to minimize the shaders we need to generate 
	* @return	The allocated resource
	*/
	FMaterialResource* AllocateResource();
}

defaultproperties
{
	bIsLayerThumbnail=False
}