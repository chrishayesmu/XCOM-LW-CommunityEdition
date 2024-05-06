/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleModuleLocationSkelVertSurface extends ParticleModuleLocationBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

enum ELocationSkelVertSurfaceSource
{
	VERTSURFACESOURCE_Vert,
	VERTSURFACESOURCE_Surface
};

/**
 *	Whether the module uses Verts or Surfaces for locations.
 *
 *	VERTSURFACESOURCE_Vert		- Use Verts as the source locations.
 *	VERTSURFACESOURCE_Surface	- Use Surfaces as the source locations.
 */
var(VertSurface)	ELocationSkelVertSurfaceSource	SourceType;

/** An offset to apply to each vert/surface */
var(VertSurface)	vector	UniversalOffset;

/** If TRUE, update the particle locations each frame with that of the vert/surface */
var(VertSurface)	bool	bUpdatePositionEachFrame;

/** If TRUE, rotate mesh emitter meshes to orient w/ the vert/surface */
var(VertSurface)	bool	bOrientMeshEmitters;

/**
 *	The parameter name of the skeletal mesh actor that supplies the SkelMeshComponent for in-game.
 */
var(VertSurface)	name	SkelMeshActorParamName;

/** The name of the skeletal mesh to use in the editor */
var(VertSurface)	editoronly	SkeletalMesh	EditorSkelMesh;

/** This module will only spawn from verts or surfaces associated with the bones in this list */
var(VertSurface)	array<Name>		ValidAssociatedBones;

/** When TRUE use the RestrictToNormal and NormalTolerance values to check surface normals */
var(VertSurface)	bool	bEnforceNormalCheck;

/** Use this normal to restrict spawning locations */
var(VertSurface)	vector	NormalToCompare;

/** Normal tolerance.  0 degrees means it must be an exact match, 180 degrees means it can be any angle. */
var(VertSurface)	float			NormalCheckToleranceDegrees;

/** Normal tolerance.  Value between 1.0 and -1.0 with 1.0 being exact match, 0.0 being everything up to
    perpendicular and -1.0 being any direction or don't restrict at all. */
var					float	NormalCheckTolerance;

/**
 *	Array of material indices that are valid materials to spawn from.
 *	If empty, any material will be considered valid
 */
var(VertSurface)	array<int>	ValidMaterialIndices;

cpptext
{
	/**
	 *	Called after loading the module.
	 */
	virtual void PostLoad();

	/**
	 *	Called when a property has change on an instance of the module.
	 *
	 *	@param	PropertyChangedEvent		Information on the change that occurred.
	 */
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	/**
	 *	Called on a particle that is freshly spawned by the emitter.
	 *	
	 *	@param	Owner		The FParticleEmitterInstance that spawned the particle.
	 *	@param	Offset		The modules offset into the data payload of the particle.
	 *	@param	SpawnTime	The time of the spawn.
	 */
	virtual void	Spawn(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime);

	/**
	 *	Called on a particle that is being updated by its emitter.
	 *	
	 *	@param	Owner		The FParticleEmitterInstance that 'owns' the particle.
	 *	@param	Offset		The modules offset into the data payload of the particle.
	 *	@param	DeltaTime	The time since the last update.
	 */
	virtual void	Update(FParticleEmitterInstance* Owner, INT Offset, FLOAT DeltaTime);

	/**
	 *	Allows the module to prep its 'per-instance' data block.
	 *	
	 *	@param	Owner		The FParticleEmitterInstance that 'owns' the particle.
	 *	@param	InstData	Pointer to the data block for this module.
	 */
	virtual UINT	PrepPerInstanceBlock(FParticleEmitterInstance* Owner, void* InstData);

	/**
	 *	Returns the number of bytes that the module requires in the particle payload block.
	 *
	 *	@param	Owner		The FParticleEmitterInstance that 'owns' the particle.
	 *
	 *	@return	UINT		The number of bytes the module needs per particle.
	 */
	virtual UINT	RequiredBytes(FParticleEmitterInstance* Owner = NULL);

	/**
	 *	Returns the number of bytes the module requires in the emitters 'per-instance' data block.
	 *	
	 *	@param	Owner		The FParticleEmitterInstance that 'owns' the particle.
	 *
	 *	@return UINT		The number of bytes the module needs per emitter instance.
	 */
	virtual UINT	RequiredBytesPerInstance(FParticleEmitterInstance* Owner = NULL);

	/**
	 *	Return TRUE if this module impacts rotation of Mesh emitters
	 *	@return	UBOOL		TRUE if the module impacts mesh emitter rotation
	 */
	virtual UBOOL	TouchesMeshRotation() const	{ return TRUE; }

	/**
	 *	Helper function used by the editor to auto-populate a placed AEmitter with any
	 *	instance parameters that are utilized.
	 *
	 *	@param	PSysComp		The particle system component to be populated.
	 */
	virtual void	AutoPopulateInstanceProperties(UParticleSystemComponent* PSysComp);

#if WITH_EDITOR
	/**
	 *	Get the number of custom entries this module has. Maximum of 3.
	 *
	 *	@return	INT		The number of custom menu entries
	 */
	virtual INT GetNumberOfCustomMenuOptions() const;

	/**
	 *	Get the display name of the custom menu entry.
	 *
	 *	@param	InEntryIndex		The custom entry index (0-2)
	 *	@param	OutDisplayString	The string to display for the menu
	 *
	 *	@return	UBOOL				TRUE if successful, FALSE if not
	 */
	virtual UBOOL GetCustomMenuEntryDisplayString(INT InEntryIndex, FString& OutDisplayString) const;

	/**
	 *	Perform the custom menu entry option.
	 *
	 *	@param	InEntryIndex		The custom entry index (0-2) to perform
	 *
	 *	@return	UBOOL				TRUE if successful, FALSE if not
	 */
	virtual UBOOL PerformCustomMenuEntry(INT InEntryIndex);
#endif

	/**
	 *	Retrieve the skeletal mesh component source to use for the current emitter instance.
	 *
	 *	@param	Owner						The particle emitter instance that is being setup
	 *
	 *	@return	USkeletalMeshComponent*		The skeletal mesh component to use as the source
	 */
	USkeletalMeshComponent* GetSkeletalMeshComponentSource(FParticleEmitterInstance* Owner);

	/**
	 *	Retrieve the position for the given socket index.
	 *
	 *	@param	Owner					The particle emitter instance that is being setup
	 *	@param	InSkelMeshComponent		The skeletal mesh component to use as the source
	 *	@param	InPrimaryVertexIndex	The index of the only vertex (vert mode) or the first vertex (surface mode)
	 *	@param	OutPosition				The position for the particle location
	 *	@param	OutRotation				Optional orientation for the particle (mesh emitters)
	 *  @param  bSpawning				When TRUE and when using normal check on surfaces, will return false if the check fails.
	 *	
	 *	@return	UBOOL					TRUE if successful, FALSE if not
	 */
	UBOOL GetParticleLocation(FParticleEmitterInstance* Owner, USkeletalMeshComponent* InSkelMeshComponent, INT InPrimaryVertexIndex, FVector& OutPosition, FQuat* OutRotation, UBOOL bSpawning = FALSE);

	/**
	 *  Check to see if the vert is influenced by a bone on our approved list.
	 *
	 *	@param	Owner					The particle emitter instance that is being setup
	 *	@param	InSkelMeshComponent		The skeletal mesh component to use as the source
	 *  @param  InVertexIndex			The vertex index of the vert to check.
	 *
	 *  @return UBOOL					TRUE if it is influenced by an approved bone, FALSE otherwise.
	 */
	UBOOL VertInfluencedByActiveBone(FParticleEmitterInstance* Owner, USkeletalMeshComponent* InSkelMeshComponent, INT InVertexIndex);

	/**
	 *	Updates the indices list with the bone index for each named bone in the editor exposed values.
	 *	
	 *	@param	Owner		The FParticleEmitterInstance that 'owns' the particle.
	 */
	void UpdateBoneIndicesList(FParticleEmitterInstance* Owner);
}

defaultproperties
{
	bSpawnModule=true
	bUpdateModule=true
	bFinalUpdateModule=true

	bSupported3DDrawMode=true

	SourceType=VERTSURFACESOURCE_Vert
	SkelMeshActorParamName="VertSurfaceActor"
	bOrientMeshEmitters=true

	bEnforceNormalCheck=false
}
