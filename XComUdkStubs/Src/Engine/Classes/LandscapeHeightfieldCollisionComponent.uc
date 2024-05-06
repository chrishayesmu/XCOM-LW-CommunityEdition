/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class LandscapeHeightfieldCollisionComponent extends PrimitiveComponent
	native(Terrain);

/** The collision height values. */
var native const UntypedBulkData_Mirror	CollisionHeightData{FWordBulkData};

/** List of layers painted on this component. Matches the WeightmapLayerAllocations array in the LandscapeComponent. */
var const array<Name> ComponentLayers;

/** Indices into the ComponentLayers array for the per-vertex dominant layer. */
var native const UntypedBulkData_Mirror	DominantLayerData{FByteBulkData};

/** Offset of component in landscape quads */
var const int SectionBaseX;
var const int SectionBaseY;

/** Size of component in collision quads */
var int CollisionSizeQuads;

/** Collision scale: (ComponentSizeQuads+1) / (CollisionSizeQuads+1) */
var float CollisionScale;

/** The flags for each collision quad. See ECollisionQuadFlags. */
var const array<byte> CollisionQuadFlags;

var const array<PhysicalMaterial> PhysicalMaterials;

/** Physics engine version of heightfield data. */
var const native pointer RBHeightfield{class NxHeightField};

/** Cached bounds, created at heightmap update time */
var const BoxSphereBounds CachedBoxSphereBounds;

cpptext
{
	enum ECollisionQuadFlags
	{
		QF_PhysicalMaterialMask = 63,	// Mask value for the physical material index, stored in the lower 6 bits.
		QF_EdgeTurned = 64,				// This quad's diagonal has been turned.
		QF_NoCollision = 128,			// This quad has no collision.
	};

	// UPrimitiveComponent interface.
	virtual void UpdateBounds();
	virtual void SetParentToWorld(const FMatrix& ParentToWorld);
	virtual void InitComponentRBPhys(UBOOL bFixed);
	virtual UBOOL PointCheck(FCheckResult& Result,const FVector& Location,const FVector& Extent,DWORD TraceFlags);
	virtual UBOOL LineCheck(FCheckResult& Result,const FVector& End,const FVector& Start,const FVector& Extent,DWORD TraceFlags);

	// UObject Interface
	virtual void Serialize(FArchive& Ar);
	virtual void BeginDestroy();
#if WITH_EDITOR
	virtual void PostEditUndo();

	// Register ourselves with the actor.
	ELandscapeSetupErrors SetupActor(UBOOL bForce = FALSE);
	void PostLoad();

	// Update Collision object for add LandscapeComponent tool
	void UpdateAddCollisions(UBOOL bForceUpdate = FALSE);

	/** Return the LandscapeComponent matching this collision component */
	class ULandscapeComponent* GetLandscapeComponent() const;

	class ULandscapeInfo* GetLandscapeInfo(UBOOL bSpawnNewActor = TRUE) const;
#endif

	/** Returns the landscape actor associated with this component. */
	class ALandscape* GetLandscapeActor() const;
	class ALandscapeProxy* GetLandscapeProxy() const;

	/** Recreate heightfield and restart physics */
	void RecreateHeightfield(UBOOL bUpdateAddCollision = TRUE);
}

defaultproperties
{
	CollideActors=TRUE
	BlockActors=TRUE
	BlockZeroExtent=TRUE
	BlockNonZeroExtent=TRUE
	BlockRigidBody=TRUE
	CastShadow=FALSE
	bAcceptsLights=FALSE
	bAcceptsDecals=FALSE
	bAcceptsStaticDecals=FALSE
	bUsePrecomputedShadows=TRUE
	bUseAsOccluder=TRUE
	bAllowCullDistanceVolume=FALSE
}
