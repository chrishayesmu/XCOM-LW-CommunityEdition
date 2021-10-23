/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MaterialInterface extends Surface
	abstract
	forcescriptorder(true)
	native(Material);

enum EMaterialUsage
{
	MATUSAGE_SkeletalMesh,
	MATUSAGE_FracturedMeshes,
	MATUSAGE_ParticleSprites,
	MATUSAGE_BeamTrails,
	MATUSAGE_ParticleSubUV,
	MATUSAGE_SpeedTree,
	MATUSAGE_StaticLighting,
	MATUSAGE_GammaCorrection,
	MATUSAGE_LensFlare,
	MATUSAGE_InstancedMeshParticles,
	MATUSAGE_FluidSurface,
	MATUSAGE_Decals,
	MATUSAGE_MaterialEffect,
	MATUSAGE_MorphTargets,
	MATUSAGE_FogVolumes,
	MATUSAGE_RadialBlur,
	MATUSAGE_InstancedMeshes,
	MATUSAGE_SplineMesh,
	MATUSAGE_ScreenDoorFade,
	MATUSAGE_APEXMesh,
	MATUSAGE_Terrain,
	MATUSAGE_Landscape,
};

/** A fence to track when the primitive is no longer used as a parent */
var native const transient RenderCommandFence_Mirror ParentRefFence{FRenderCommandFence};

/** 
 *	Material interface settings for Lightmass
 */
struct native LightmassMaterialInterfaceSettings
{
	/** If TRUE, forces translucency to cast static shadows as if the material were masked. */
	var(Material)	bool		bCastShadowAsMasked;
	/** Scales the emissive contribution of this material to static lighting. */
	var(Material)	float		EmissiveBoost;
	/** Scales the diffuse contribution of this material to static lighting. */
	var(Material)	float		DiffuseBoost;
	/** Scales the specular contribution of this material to static lighting. */
	var				float		SpecularBoost;
	/** 
	 * Scales the resolution that this material's attributes were exported at. 
	 * This is useful for increasing material resolution when details are needed.
	 */
	var(Material)	float		ExportResolutionScale;
	/** Scales the penumbra size of distance field shadows.  This is useful to get softer precomputed shadows on certain material types like foliage. */
	var(Material)	float		DistanceFieldPenumbraScale;
	
	/** Boolean override flags - only used in MaterialInstance* cases. */
	/** If TRUE, override the bCastShadowAsMasked setting of the parent material. */
	var bool bOverrideCastShadowAsMasked;
	/** If TRUE, override the emissive boost setting of the parent material. */
	var bool bOverrideEmissiveBoost;
	/** If TRUE, override the diffuse boost setting of the parent material. */
	var bool bOverrideDiffuseBoost;
	/** If TRUE, override the specular boost setting of the parent material. */
	var bool bOverrideSpecularBoost;
	/** If TRUE, override the export resolution scale setting of the parent material. */
	var bool bOverrideExportResolutionScale;
	/** If TRUE, override the distance field penumbra scale setting of the parent material. */
	var bool bOverrideDistanceFieldPenumbraScale;

	structdefaultproperties
	{
		bCastShadowAsMasked=false
		EmissiveBoost=1.0
		DiffuseBoost=1.0
		SpecularBoost=1.0
		ExportResolutionScale=1.0
		DistanceFieldPenumbraScale=1.0
	}
};

/** The Lightmass settings for this object. */
var(Lightmass)	protected{protected}	LightmassMaterialInterfaceSettings		LightmassSettings <ScriptOrder=true>;

cpptext
{
	/**
	 * Get the material which this is an instance of.
	 * Warning - This is platform dependent!  Do not call GetMaterial(GCurrentMaterialPlatform) and save that reference,
	 * as it will be different depending on the current platform.  Instead call GetMaterial(MSP_BASE) to get the base material and save that.
	 * When getting the material for rendering/checking usage, GetMaterial(GCurrentMaterialPlatform) is fine.
	 *
	 * @param Platform - The platform to get material for.
	 */
	virtual class UMaterial* GetMaterial(EMaterialShaderPlatform Platform = GCurrentMaterialPlatform) PURE_VIRTUAL(UMaterialInterface::GetMaterial,return NULL;);

	/**Fix up for deprecated properties*/
	virtual void PostLoad ();

	/**
	* Tests this material for dependency on a given material.
	* @param	TestDependency - The material to test for dependency upon.
	* @return	True if the material is dependent on TestDependency.
	*/
	virtual UBOOL IsDependent(UMaterialInterface* TestDependency) { return TestDependency == this; }

	/**
	* Returns a pointer to the FMaterialRenderProxy used for rendering.
	*
	* @param	Selected	specify TRUE to return an alternate material used for rendering this material when part of a selection
	*						@note: only valid in the editor!
	*
	* @return	The resource to use for rendering this material instance.
	*/
	virtual FMaterialRenderProxy* GetRenderProxy(UBOOL Selected, UBOOL bHovered=FALSE) const PURE_VIRTUAL(UMaterialInterface::GetRenderProxy,return NULL;);

	/**
	* Returns a pointer to the physical material used by this material instance.
	* @return The physical material.
	*/
	virtual UPhysicalMaterial* GetPhysicalMaterial() const PURE_VIRTUAL(UMaterialInterface::GetPhysicalMaterial,return NULL;);

	/** Returns the textures used to render this material for the given platform. */
	virtual void GetUsedTextures(TArray<UTexture*> &OutTextures, EMaterialShaderPlatform Platform = MSP_BASE, UBOOL bAllPlatforms = FALSE) 
		PURE_VIRTUAL(UMaterialInterface::GetUsedTextures,);

	/**
	* Checks whether the specified texture is needed to render the material instance.
	* @param Texture	The texture to check.
	* @return UBOOL - TRUE if the material uses the specified texture.
	*/
	virtual UBOOL UsesTexture(const UTexture* Texture) PURE_VIRTUAL(UMaterialInterface::UsesTexture,return FALSE;);

	/**
	 * Overrides a specific texture (transient)
	 *
	 * @param InTextureToOverride The texture to override
	 * @param OverrideTexture The new texture to use
	 */
	virtual void OverrideTexture( UTexture* InTextureToOverride, UTexture* OverrideTexture ) PURE_VIRTUAL(UMaterialInterface::OverrideTexture,return;);

	/**
	 * Checks if the material can be used with the given usage flag.  
	 * If the flag isn't set in the editor, it will be set and the material will be recompiled with it.
	 * @param Usage - The usage flag to check
	 * @return UBOOL - TRUE if the material can be used for rendering with the given type.
	 */
	virtual UBOOL CheckMaterialUsage(EMaterialUsage Usage) PURE_VIRTUAL(UMaterialInterface::CheckMaterialUsage,return FALSE;);

	/**
	* Allocates a new material resource
	* @return	The allocated resource
	*/
	virtual FMaterialResource* AllocateResource() PURE_VIRTUAL(UMaterialInterface::AllocateResource,return NULL;);

	/**
	 * Gets the static permutation resource if the instance has one
	 * @return - the appropriate FMaterialResource if one exists, otherwise NULL
	 */
	virtual FMaterialResource* GetMaterialResource(EMaterialShaderPlatform Platform = GCurrentMaterialPlatform) { return NULL; }

	/**
	 * @return the flattened texture for the material
	 */
	virtual UTexture* GetMobileTexture(const INT /* EMobileTextureUnit */ MobileTextureUnit);

	/**
	 * Used by various commandlets to purge editor only and platform-specific data from various objects
	 * 
	 * @param PlatformsToKeep Platforms for which to keep platform-specific data
	 * @param bStripLargeEditorData If TRUE, data used in the editor, but large enough to bloat download sizes, will be removed
	 */
	virtual void StripData(UE3::EPlatformType PlatformsToKeep, UBOOL bStripLargeEditorData);

	/**
	 * Compiles a FMaterialResource on the given platform with the given static parameters
	 *
	 * @param StaticParameters - The set of static parameters to compile for
	 * @param StaticPermutation - The resource to compile
	 * @param Platform - The platform to compile for
	 * @param MaterialPlatform - The material platform to compile for
	 * @param bFlushExistingShaderMaps - Indicates that existing shader maps should be discarded
	 * @return TRUE if compilation was successful or not necessary
	 */
	virtual UBOOL CompileStaticPermutation(
		FStaticParameterSet* StaticParameters, 
		FMaterialResource* StaticPermutation, 
		EShaderPlatform Platform, 
		EMaterialShaderPlatform MaterialPlatform,
		UBOOL bFlushExistingShaderMaps,
		UBOOL bDebugDump)
		PURE_VIRTUAL(UMaterialInterface::CompileStaticPermutation,return FALSE;);

	/**
	* Gets the value of the given static switch parameter
	*
	* @param	ParameterName	The name of the static switch parameter
	* @param	OutValue		Will contain the value of the parameter if successful
	* @return					True if successful
	*/
	virtual UBOOL GetStaticSwitchParameterValue(FName ParameterName,UBOOL &OutValue,FGuid &OutExpressionGuid) 
		PURE_VIRTUAL(UMaterialInterface::GetStaticSwitchParameterValue,return FALSE;);

	/**
	* Gets the value of the given static component mask parameter
	*
	* @param	ParameterName	The name of the parameter
	* @param	R, G, B, A		Will contain the values of the parameter if successful
	* @return					True if successful
	*/
	virtual UBOOL GetStaticComponentMaskParameterValue(FName ParameterName, UBOOL &R, UBOOL &G, UBOOL &B, UBOOL &A, FGuid &OutExpressionGuid) 
		PURE_VIRTUAL(UMaterialInterface::GetStaticComponentMaskParameterValue,return FALSE;);

	/**
	* Gets the compression format of the given normal parameter
	*
	* @param	ParameterName	The name of the parameter
	* @param	CompressionSettings	Will contain the values of the parameter if successful
	* @return					True if successful
	*/
	virtual UBOOL GetNormalParameterValue(FName ParameterName, BYTE& OutCompressionSettings, FGuid &OutExpressionGuid)
		PURE_VIRTUAL(UMaterialInterface::GetNormalParameterValue,return FALSE;);

	/**
	* Gets the weightmap index of the given terrain layer weight parameter
	*
	* @param	ParameterName	The name of the parameter
	* @param	OutWeightmapIndex	Will contain the values of the parameter if successful
	* @return					True if successful
	*/
	virtual UBOOL GetTerrainLayerWeightParameterValue(FName ParameterName, INT& OutWeightmapIndex, FGuid &OutExpressionGuid)
		PURE_VIRTUAL(UMaterialInterface::GetTerrainLayerWeightParameterValue,return FALSE;);

	virtual UBOOL IsFallbackMaterial() { return FALSE; }

	/** @return The material's view relevance. */
	FMaterialViewRelevance GetViewRelevance();

	INT GetWidth() const;
	INT GetHeight() const;

	virtual const FGuid& GetLightingGuid() const
	{
#if WITH_EDITORONLY_DATA
		return LightingGuid;
#else
		static const FGuid NullGuid( 0, 0, 0, 0 );
		return NullGuid; 
#endif // WITH_EDITORONLY_DATA
	}

	virtual void SetLightingGuid()
	{
#if WITH_EDITORONLY_DATA
		LightingGuid = appCreateGuid();
#endif // WITH_EDITORONLY_DATA
	}

	// USurface interface
	virtual FLOAT GetSurfaceWidth() const { return GetWidth(); }
	virtual FLOAT GetSurfaceHeight() const { return GetHeight(); }

	// UObject interface
	virtual void BeginDestroy();
	virtual UBOOL IsReadyForFinishDestroy();
	virtual void Serialize(FArchive& Ar);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	/**
	 *	Serialize the given shader map to the given archive
	 *
	 *	@param	InShaderMap				The shader map to serialize; when loading will be NULL.
	 *	@param	Ar						The archvie to serialize it to.
	 *
	 *	@return	FMaterialShaderMap*		The shader map serialized
	 */
	FMaterialShaderMap* SerializeShaderMap(FMaterialShaderMap* InShaderMap, FArchive& Ar);
	
	/**
	 *	Check if the textures have changed since the last time the material was
	 *	serialized for Lightmass... Update the lists while in here.
	 *	NOTE: This will mark the package dirty if they have changed.
	 *
	 *	@return	UBOOL	TRUE if the textures have changed.
	 *					FALSE if they have not.
	 */
	virtual UBOOL UpdateLightmassTextureTracking() 
	{ 
		return FALSE; 
	}
	
	/** @return The override bOverrideCastShadowAsMasked setting of the material. */
	inline UBOOL GetOverrideCastShadowAsMasked() const
	{
		return LightmassSettings.bOverrideCastShadowAsMasked;
	}
	/** @return The override emissive boost setting of the material. */
	inline UBOOL GetOverrideEmissiveBoost() const
	{
		return LightmassSettings.bOverrideEmissiveBoost;
	}
	/** @return The override diffuse boost setting of the material. */
	inline UBOOL GetOverrideDiffuseBoost() const
	{
		return LightmassSettings.bOverrideDiffuseBoost;
	}
	/** @return The override specular boost setting of the material. */
	inline UBOOL GetOverrideSpecularBoost() const
	{
		return LightmassSettings.bOverrideSpecularBoost;
	}
	/** @return The override export resolution scale setting of the material. */
	inline UBOOL GetOverrideExportResolutionScale() const
	{
		return LightmassSettings.bOverrideExportResolutionScale;
	}
	inline UBOOL GetOverrideDistanceFieldPenumbraScale() const
	{
		return LightmassSettings.bOverrideDistanceFieldPenumbraScale;
	}

	/** @return	The bCastShadowAsMasked value for this material. */
	virtual UBOOL GetCastShadowAsMasked() const
	{
		return LightmassSettings.bCastShadowAsMasked;
	}
	/** @return	The Emissive boost value for this material. */
	virtual FLOAT GetEmissiveBoost() const
	{
		return LightmassSettings.EmissiveBoost;
	}
	/** @return	The Diffuse boost value for this material. */
	virtual FLOAT GetDiffuseBoost() const
	{
		return LightmassSettings.DiffuseBoost;
	}
	/** @return	The Specular boost value for this material. */
	virtual FLOAT GetSpecularBoost() const
	{
		return LightmassSettings.SpecularBoost;
	}
	/** @return	The ExportResolutionScale value for this material. */
	virtual FLOAT GetExportResolutionScale() const
	{
		return LightmassSettings.ExportResolutionScale;
	}
	virtual FLOAT GetDistanceFieldPenumbraScale() const
	{
		return LightmassSettings.DistanceFieldPenumbraScale;
	}

	/** @param	bInOverrideCastShadowAsMasked	The override CastShadowAsMasked setting to set. */
	inline void SetOverrideCastShadowAsMasked(UBOOL bInOverrideCastShadowAsMasked)
	{
		LightmassSettings.bOverrideCastShadowAsMasked = bInOverrideCastShadowAsMasked;
	}
	/** @param	bInOverrideEmissiveBoost	The override emissive boost setting to set. */
	inline void SetOverrideEmissiveBoost(UBOOL bInOverrideEmissiveBoost)
	{
		LightmassSettings.bOverrideEmissiveBoost = bInOverrideEmissiveBoost;
	}
	/** @param bInOverrideDiffuseBoost		The override diffuse boost setting of the parent material. */
	inline void SetOverrideDiffuseBoost(UBOOL bInOverrideDiffuseBoost)
	{
		LightmassSettings.bOverrideDiffuseBoost = bInOverrideDiffuseBoost;
	}
	/** @param bInOverrideSpecularBoost		The override specular boost setting of the parent material. */
	inline void SetOverrideSpecularBoost(UBOOL bInOverrideSpecularBoost)
	{
		LightmassSettings.bOverrideSpecularBoost = bInOverrideSpecularBoost;
	}
	/** @param bInOverrideExportResolutionScale	The override export resolution scale setting of the parent material. */
	inline void SetOverrideExportResolutionScale(UBOOL bInOverrideExportResolutionScale)
	{
		LightmassSettings.bOverrideExportResolutionScale = bInOverrideExportResolutionScale;
	}
	inline void SetOverrideDistanceFieldPenumbraScale(UBOOL bInOverrideDistanceFieldPenumbraScale)
	{
		LightmassSettings.bOverrideDistanceFieldPenumbraScale = bInOverrideDistanceFieldPenumbraScale;
	}

	/** @param	InCastShadowAsMasked	The CastShadowAsMasked value for this material. */
	inline void SetCastShadowAsMasked(UBOOL InCastShadowAsMasked)
	{
		LightmassSettings.bCastShadowAsMasked = InCastShadowAsMasked;
	}
	/** @param	InEmissiveBoost		The Emissive boost value for this material. */
	inline void SetEmissiveBoost(FLOAT InEmissiveBoost)
	{
		LightmassSettings.EmissiveBoost = InEmissiveBoost;
	}
	/** @param	InDiffuseBoost		The Diffuse boost value for this material. */
	inline void SetDiffuseBoost(FLOAT InDiffuseBoost)
	{
		LightmassSettings.DiffuseBoost = InDiffuseBoost;
	}
	/** @param	InSpecularBoost		The Specular boost value for this material. */
	inline void SetSpecularBoost(FLOAT InSpecularBoost)
	{
		LightmassSettings.SpecularBoost = InSpecularBoost;
	}
	/** @param	InExportResolutionScale		The ExportResolutionScale value for this material. */
	inline void SetExportResolutionScale(FLOAT InExportResolutionScale)
	{
		LightmassSettings.ExportResolutionScale = InExportResolutionScale;
	}
	inline void SetDistanceFieldPenumbraScale(FLOAT InDistanceFieldPenumbraScale)
	{
		LightmassSettings.DistanceFieldPenumbraScale = InDistanceFieldPenumbraScale;
	}

	/**
	 *	Get all of the textures in the expression chain for the given property (ie fill in the given array with all textures in the chain).
	 *
	 *	@param	InProperty				The material property chain to inspect, such as MP_DiffuseColor.
	 *	@param	OutTextures				The array to fill in all of the textures.
	 *	@param	OutTextureParamNames	Optional array to fill in with texture parameter names.
	 *	@param	InStaticParameterSet	Optional static parameter set - if specified only follow StaticSwitches according to its settings
	 *
	 *	@return	UBOOL			TRUE if successful, FALSE if not.
	 */
	virtual UBOOL GetTexturesInPropertyChain(EMaterialProperty InProperty, TArray<UTexture*>& OutTextures,  TArray<FName>* OutTextureParamNames, class FStaticParameterSet* InStaticParameterSet)
		PURE_VIRTUAL(UMaterialInterface::GetTexturesInPropertyChain,return FALSE;);

	/**
	 * Returns the lookup texture to be used in the physical material mask.  Tries to get the parents lookup texture if not overridden here. 
	 */
	virtual UTexture2D* GetPhysicalMaterialMaskTexture() const { return NULL; }

	/**
	 * Returns the black physical material to be used in the physical material mask.  Tries to get the parents black phys mat if not overridden here. 
	 */
	virtual UPhysicalMaterial* GetBlackPhysicalMaterial() const { return NULL; }

	/**
	 * Returns the white physical material to be used in the physical material mask.  Tries to get the parents white phys mat if not overridden here. 
	 */
	virtual UPhysicalMaterial* GetWhitePhysicalMaterial() const { return NULL; }

	/** 
	 * Returns the UV channel that should be used to look up physical material mask information 
	 */
	virtual INT GetPhysMaterialMaskUVChannel() const { return -1; }

	/** 
	 * Returns True if this material has a valid physical material mask setup.
 	 */
	UBOOL HasValidPhysicalMaterialMask() const;

	/**
	 * Determines the texel on the physical material mask that was hit and returns the physical material corresponding to hit texel's color
	 * 
	 * @param HitUV the UV that was hit during collision.
	 */
	UPhysicalMaterial* DetermineMaskedPhysicalMaterialFromUV( const FVector2D& HitUV ) const;
}

/** The mesh used by the material editor to preview the material.*/
var() editoronly string PreviewMesh;

/** Unique ID for this material, used for caching during distributed lighting */
var private const editoronly Guid LightingGuid;


/**
 * Mobile material properties
 */

/** When enabled, the base texture will be generated automatically by statically 'flattening' the graph network into a texture. */
var (Mobile) bool bAutoFlattenMobile;

/** Base (diffuse) texture, or a texture that was generated by flattening the graph network */
var(Mobile) duplicatetransient texture MobileBaseTexture;
var deprecated duplicatetransient texture FlattenedTexture;

/** Texture coordinates from mesh vertex to use when sampling base texture on mobile platforms */
var(Mobile) EMobileTexCoordsSource MobileBaseTextureTexCoordsSource;

/** Normal map texture.  If specified, this enables per pixel lighting when used in combination with other material features. */
var(Mobile) texture MobileNormalTexture;

/** Enables baked ambient occlusion from mesh vertices and selects which vertex color channel to get the AO data from */
var(Mobile) EMobileAmbientOcclusionSource MobileAmbientOcclusionSource;

/** When enabled, primitives using this material may be fogged.  Disable this to improve performance for primitives that don't need fog. */
var(Mobile) bool bMobileAllowFog;


/** Enables dynamic specular lighting from the single most prominent light source */
var(Mobile, Specular) bool bUseMobileSpecular;
var deprecated bool bUseMobileVertexSpecular;

/** Enables per-pixel specular for this material (requires normal map) */
var(Mobile, Specular) bool bUseMobilePixelSpecular<EditCondition=bUseMobileSpecular>;

/** Material specular color */
var(Mobile, Specular) LinearColor MobileSpecularColor<EditCondition=bUseMobileSpecular>;

/** When specular is enabled, this sets the specular power.  Lower values yield a wider highlight, higher values yield a sharper highlight */
var(Mobile, Specular) float MobileSpecularPower<EditCondition=bUseMobileSpecular>;

/** Determines how specular values are masked.  Constant: Mask is disabled.  Luminance: Diffuse RGB luminance used as mask.  Diffuse Red/Green/Blue: Use a specific channel of the diffuse texture as the specular mask.  Mask Texture RGB: Uses the color from the mask texture */
var(Mobile, Specular) EMobileSpecularMask MobileSpecularMask;


/** Emissive texture.  If the emissive color source is set to 'Emissive Texture', setting this texture will enable emissive lighting */
var(Mobile, Emissive) texture MobileEmissiveTexture;

/** Mobile emissive color source */
var(Mobile, Emissive) EMobileEmissiveColorSource MobileEmissiveColorSource;

/** Mobile emissive color.  Only used when MobileEmissiveColorSource is set to 'Constant' */
var(Mobile, Emissive) LinearColor MobileEmissiveColor;

/** Selects a source for emissive light masking */
var(Mobile, Emissive) EMobileValueSource MobileEmissiveMaskSource;


/** Spherical environment map texture.  When specified, spherical environment mapping will be enabled for this material. */
var(Mobile, Environment) texture MobileEnvironmentTexture;

/** Selects a source for environment map amount */
var(Mobile, Environment) EMobileValueSource MobileEnvironmentMaskSource;

/** Sets how much the environment map texture contributes to the final color */ 
var(Mobile, Environment) float MobileEnvironmentAmount <ClampMin=0.0 | UIMax=1.0>;

/** When environment mapping is enabled, this sets how the environment color is blended with the base color. */
var(Mobile, Environment) EMobileEnvironmentBlendMode MobileEnvironmentBlendMode;

/** Environment map color scale */
var(Mobile, Environment) LinearColor MobileEnvironmentColor;

/** Environment mapping fresnel amount.  Set this to zero for best performance. */
var(Mobile, Environment) float MobileEnvironmentFresnelAmount <ClampMin=0.0 | UIMax=1.0>;

/** Environment mapping fresnel exponent.  Set this to 1.0 for best performance. */
var(Mobile, Environment) float MobileEnvironmentFresnelExponent <ClampMin=0.01 | UIMax=8.0>;


/** When set to anything other than zero, enables rim lighting for this material and sets the amount of rim lighting to apply */
var(Mobile, RimLighting) float MobileRimLightingStrength <ClampMin=0.0 | UIMax=4.0>;

/** Sets the exponent used for rim lighting */
var(Mobile, RimLighting) float MobileRimLightingExponent <ClampMin=0.01 | UIMax=8.0>;

/** Selects a source for rim light masking */
var(Mobile, RimLighting) EMobileValueSource MobileRimLightingMaskSource;

/** Rim light color */
var(Mobile, RimLighting) LinearColor MobileRimLightingColor;


/** Enables a bump offset effect for this material.  A mask texture must be supplied.  The bump offset amount is stored in the mask texture's RED channel. */
var(Mobile, BumpOffset) bool bUseMobileBumpOffset;

/** Bump offset reference plane */
var(Mobile, BumpOffset) float MobileBumpOffsetReferencePlane <EditCondition=bUseMobileBumpOffset>;

/** Bump height ratio */
var(Mobile, BumpOffset) float MobileBumpOffsetHeightRatio <EditCondition=bUseMobileBumpOffset>;


/** General purpose mask texture used for bump offset amount, texture blending, etc. */
var(Mobile, Masking) texture MobileMaskTexture;

/** Texture coordinates from mesh vertex to use when sampling mask texture */
var(Mobile, Masking) EMobileTexCoordsSource MobileMaskTextureTexCoordsSource;


/** Detail texture to use for blending the base texture */
var(Mobile, TextureBlending) texture MobileDetailTexture;

/** Texture coordinates from mesh vertex to use when sampling detail texture */
var(Mobile, TextureBlending) EMobileTexCoordsSource MobileDetailTextureTexCoordsSource;

/** Where the blend factor comes from, for blending the base texture with the detail texture */
var(Mobile, TextureBlending) EMobileTextureBlendFactorSource MobileTextureBlendFactorSource;

/** Locks use of the detail texture and does not allow it to be forced off by system settings */
var(Mobile, TextureBlending) bool bLockColorBlending;


/** Whether to use uniform color scaling (mesh particles) or not */
var(Mobile, ColorBlending) bool bUseMobileUniformColorMultiply;

/** Default color to modulate each vertex by */
var(Mobile, ColorBlending) LinearColor DefaultUniformColor;

/** Whether to use per vertex color scaling */
var(Mobile, ColorBlending) bool bUseMobileVertexColorMultiply;


/** Enables texture transform features */
var(Mobile, TextureTransform) bool bUseMobileTextureTransform;

/** Which texture UVs to transform */
var(Mobile, TextureTransform) EMobileTextureTransformTarget MobileTextureTransformTarget <EditCondition=bUseMobileTextureTransform>;

/** Horizontal center for texture rotation/scale */
var(Mobile, TextureTransform) float TransformCenterX <EditCondition=bUseMobileTextureTransform>;

/** Vertical center for texture rotation/scale */
var(Mobile, TextureTransform) float TransformCenterY <EditCondition=bUseMobileTextureTransform>;

/** Horizontal speed for texture panning */
var(Mobile, TextureTransform) float PannerSpeedX <EditCondition=bUseMobileTextureTransform>;

/** Vertical speed for texture panning */
var(Mobile, TextureTransform) float PannerSpeedY <EditCondition=bUseMobileTextureTransform>;

/** Texture rotation speed in radians per second */
var(Mobile, TextureTransform) float RotateSpeed <EditCondition=bUseMobileTextureTransform>;

/** Fixed horizontal texture scale (around the rotation center) */
var(Mobile, TextureTransform) float FixedScaleX <EditCondition=bUseMobileTextureTransform>;

/** Fixed vertical texture scale (around the rotation center) */
var(Mobile, TextureTransform) float FixedScaleY <EditCondition=bUseMobileTextureTransform>;

/** Horizontal texture scale applied to a sine wave */
var(Mobile, TextureTransform) float SineScaleX <EditCondition=bUseMobileTextureTransform>;

/** Vertical texture scale applied to a sine wave */
var(Mobile, TextureTransform) float SineScaleY <EditCondition=bUseMobileTextureTransform>;

/** Multiplier for sine wave texture scaling frequency */
var(Mobile, TextureTransform) float SineScaleFrequencyMultipler <EditCondition=bUseMobileTextureTransform>;


/** Enables per-vertex movement on a wave (for use with trees and similar objects) */
var(Mobile, VertexAnimation) bool bUseMobileWaveVertexMovement;

/** Frequency adjustment for wave on vertex positions */
var(Mobile, VertexAnimation) float MobileTangentVertexFrequencyMultiplier<EditCondition=bUseMobileWaveVertexMovement>;

/** Frequency adjustment for wave on vertex positions */
var(Mobile, VertexAnimation) float MobileVerticalFrequencyMultiplier<EditCondition=bUseMobileWaveVertexMovement>;

/** Amplitude of adjustments for wave on vertex positions*/
var(Mobile, VertexAnimation) float MobileMaxVertexMovementAmplitude<EditCondition=bUseMobileWaveVertexMovement>;

/** Frequency of entire object sway */
var(Mobile, VertexAnimation) float MobileSwayFrequencyMultiplier<EditCondition=bUseMobileWaveVertexMovement>;

/** Frequency of entire object sway */
var(Mobile, VertexAnimation) float MobileSwayMaxAngle<EditCondition=bUseMobileWaveVertexMovement>;


native final noexport function Material GetMaterial();

/**
* Returns a pointer to the physical material used by this material instance.
* @return The physical material.
*/
native final noexport function PhysicalMaterial GetPhysicalMaterial() const;

// Get*ParameterValue - Gets the entry from the ParameterValues for the named parameter.
// Returns false is parameter is not found.

native function bool GetParameterDesc(name ParameterName, out String OutDesc);
native function bool GetFontParameterValue(name ParameterName,out font OutFontValue, out int OutFontPage);
native function bool GetScalarParameterValue(name ParameterName, out float OutValue);
native function bool GetScalarCurveParameterValue(name ParameterName, out InterpCurveFloat OutValue);
native function bool GetTextureParameterValue(name ParameterName, out Texture OutValue);
native function bool GetVectorParameterValue(name ParameterName, out LinearColor OutValue);
native function bool GetVectorCurveParameterValue(name ParameterName, out InterpCurveVector OutValue);
native function bool GetGroupName(name ParameterName, out name GroupName);

/**
 * Forces the streaming system to disregard the normal logic for the specified duration and
 * instead always load all mip-levels for all textures used by this material.
 *
 * @param OverrideForceMiplevelsToBeResident	- Whether to use (TRUE) or ignore (FALSE) the bForceMiplevelsToBeResidentValue parameter.
 * @param bForceMiplevelsToBeResidentValue		- TRUE forces all mips to stream in. FALSE lets other factors decide what to do with the mips.
 * @param ForceDuration							- Number of seconds to keep all mip-levels in memory, disregarding the normal priority logic. Negative value turns it off.
 * @param CinematicTextureGroups				- Bitfield indicating texture groups that should use extra high-resolution mips
 */
native function SetForceMipLevelsToBeResident( bool OverrideForceMiplevelsToBeResident, bool bForceMiplevelsToBeResidentValue, float ForceDuration, optional int CinematicTextureGroups = 0 );

defaultproperties
{
	bUseMobileTextureTransform=FALSE
	MobileTextureTransformTarget=MTTT_BaseTexture

	//default to the center of the texture for scaling and rotating
	TransformCenterX=0.5
	TransformCenterY=0.5

	PannerSpeedX=0.0
	PannerSpeedY=0.0

	RotateSpeed=0.0

	FixedScaleX=1.0
	FixedScaleY=1.0

	SineScaleX=0.0
	SineScaleY=0.0
	SineScaleFrequencyMultipler=1.0

	bUseMobileSpecular=FALSE
	bUseMobilePixelSpecular=FALSE
	MobileSpecularColor=(R=1.0,G=1.0,B=1.0,A=1.0)
	MobileSpecularPower=16.0
	MobileSpecularMask=MSM_Constant
	MobileAmbientOcclusionSource=MAOS_Disabled

	MobileTextureBlendFactorSource=MTBFS_VertexColor
	MobileBaseTextureTexCoordsSource=MTCS_TexCoords0
	MobileDetailTextureTexCoordsSource=MTCS_TexCoords1
	MobileMaskTextureTexCoordsSource=MTCS_TexCoords0

	MobileEmissiveColorSource=MECS_EmissiveTexture
	MobileEmissiveColor=(R=1.0,G=1.0,B=1.0,A=1.0)
	MobileEmissiveMaskSource=MVS_Constant

	MobileEnvironmentAmount=1.0
	MobileEnvironmentMaskSource=MVS_Constant
	MobileEnvironmentBlendMode=MEBM_Add
	MobileEnvironmentColor=(R=1.0,G=1.0,B=1.0,A=1.0)
	MobileEnvironmentFresnelAmount=0.0
	MobileEnvironmentFresnelExponent=1.0

	MobileRimLightingStrength=0.0
	MobileRimLightingExponent=2.0
	MobileRimLightingColor=(R=1.0,G=1.0,B=1.0,A=1.0)
	MobileRimLightingMaskSource=MVS_Constant

	MobileBumpOffsetReferencePlane = 0.5;
	MobileBumpOffsetHeightRatio = 0.05;

	bUseMobileWaveVertexMovement = FALSE;
	MobileTangentVertexFrequencyMultiplier = .125;
	MobileVerticalFrequencyMultiplier = .1;
	MobileMaxVertexMovementAmplitude = 5.0;
	MobileSwayFrequencyMultiplier=.07;
	MobileSwayMaxAngle=2.0;


	bMobileAllowFog = TRUE;
}