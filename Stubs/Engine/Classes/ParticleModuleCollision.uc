/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleModuleCollision extends ParticleModuleCollisionBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

/**
 *	How much to `slow' the velocity of the particle after a collision.
 *	Value is obtained using the EmitterTime at particle spawn.
 */
var(Collision)					rawdistributionvector		DampingFactor;
/**
 *	How much to `slow' the rotation of the particle after a collision.
 *	Value is obtained using the EmitterTime at particle spawn.
 */
var(Collision)					rawdistributionvector		DampingFactorRotation;
/**
 *	The maximum number of collisions a particle can have. 
 *  Value is obtained using the EmitterTime at particle spawn. 
 */
var(Collision)					rawdistributionfloat		MaxCollisions;
/**
 *	What to do once a particles MaxCollisions is reached.
 *	One of the following:
 *	EPCC_Kill
 *		Kill the particle when MaxCollisions is reached
 *	EPCC_Freeze
 *		Freeze in place, NO MORE UPDATES
 *	EPCC_HaltCollisions,
 *		Stop collision checks, keep updating everything
 *	EPCC_FreezeTranslation,
 *		Stop translations, keep updating everything else
 *	EPCC_FreezeRotation,
 *		Stop rotations, keep updating everything else
 *	EPCC_FreezeMovement
 *		Stop all movement, keep updating
 */
var(Collision)					EParticleCollisionComplete	CollisionCompletionOption;
/** 
 *	If TRUE, physic will be applied between a particle and the 
 *	object it collides with. 
 *	This is one-way - particle --> object. The particle does 
 *	not have physics applied to it - it just generates an 
 *	impulse applied to the object it collides with. 
 */
var(Collision)					bool						bApplyPhysics;
/** 
 *	The mass of the particle - for use when bApplyPhysics is TRUE. 
 *	Value is obtained using the EmitterTime at particle spawn. 
 */
var(Collision)					rawdistributionfloat		ParticleMass;

/**
 *	The directional scalar value - used to scale the bounds to 
 *	'assist' in avoiding inter-penetration or large gaps.
 */
var(Collision)					float						DirScalar;

/**
 *	If TRUE, then collisions with Pawns will still react, but 
 *	the UsedMaxCollisions count will not be decremented. 
 *	(ie., They don't 'count' as collisions)
 */
var(Collision)					bool						bPawnsDoNotDecrementCount;
/**
 *	If TRUE, then collisions that do not have a vertical hit 
 *	normal will still react, but UsedMaxCollisions count will 
 *	not be decremented. (ie., They don't 'count' as collisions)
 *	Useful for having particles come to rest on floors.
 */
var(Collision)					bool						bOnlyVerticalNormalsDecrementCount;
/**
 *	The fudge factor to use to determine vertical.
 *	True vertical will have a Hit.Normal.Z == 1.0
 *	This will allow for Z components in the range of
 *	[1.0-VerticalFudgeFactor..1.0]
 *	to count as vertical collisions.
 */
var(Collision)					float						VerticalFudgeFactor;

/**
 *	How long to delay before checking a particle for collisions.
 *	Value is retrieved using the EmitterTime.
 *	During update, the particle flag IgnoreCollisions will be 
 *	set until the particle RelativeTime has surpassed the 
 *	DelayAmount.
 */
var(Collision)					rawdistributionfloat		DelayAmount;

/**	If TRUE, when the WorldInfo.bDropDetail flag is set, the module will be ignored. */
var(Performance)				bool						bDropDetail;

/** If TRUE, Particle collision only if particle system is currently being rendered. */
var(Performance)				bool						bCollideOnlyIfVisible;

/** Max distance at which particle collision will occur. */
var(Performance)				float						MaxCollisionDistance;

cpptext
{
	virtual void	Spawn(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime);
	virtual void	Update(FParticleEmitterInstance* Owner, INT Offset, FLOAT DeltaTime);
	virtual UINT	RequiredBytes(FParticleEmitterInstance* Owner = NULL);

	/**
	 *	Returns the number of bytes the module requires in the emitters 'per-instance' data block.
	 *	
	 *	@param	Owner		The FParticleEmitterInstance that 'owns' the particle.
	 *
	 *	@return UINT		The number of bytes the module needs per emitter instance.
	 */
	virtual UINT RequiredBytesPerInstance(FParticleEmitterInstance* Owner = NULL);

	/**
	 *	Allows the module to prep its 'per-instance' data block.
	 *	
	 *	@param	Owner		The FParticleEmitterInstance that 'owns' the particle.
	 *	@param	InstData	Pointer to the data block for this module.
	 */
	virtual UINT PrepPerInstanceBlock(FParticleEmitterInstance* Owner, void* InstData);

	/**
	 *	Called when the module is created, this function allows for setting values that make
	 *	sense for the type of emitter they are being used in.
	 *
	 *	@param	Owner			The UParticleEmitter that the module is being added to.
	 */
	virtual void SetToSensibleDefaults(UParticleEmitter* Owner);
	
	virtual UBOOL GenerateLODModuleValues(UParticleModule* SourceModule, FLOAT Percentage, UParticleLODLevel* LODLevel);

	/**
	 *	Perform the desired collision check for this module.
	 *	
	 *	@param	Owner			The emitter instance that owns the particle being checked
	 *	@param	InParticle		The particle being checked for a collision
	 *	@param	Hit				The hit results to fill in for a collision
	 *	@param	SourceActor		The source actor for the check
	 *	@param	End				The end position for the check
	 *	@param	Start			The start position for the check
	 *	@param	TraceFlags		The trace flags to use for the check
	 *	@param	Extent			The extent to use for the check
	 *	
	 *	@return UBOOL			TRUE if a collision occurred.
	 */
	virtual UBOOL PerformCollisionCheck(FParticleEmitterInstance* Owner, FBaseParticle* InParticle, 
		FCheckResult& Hit, AActor* SourceActor, const FVector& End, const FVector& Start, DWORD TraceFlags, const FVector& Extent);
}

defaultproperties
{
	bSpawnModule=true
	bUpdateModule=true

	Begin Object Class=DistributionVectorUniform Name=DistributionDampingFactor
	End Object
	DampingFactor=(Distribution=DistributionDampingFactor)

	Begin Object Class=DistributionVectorConstant Name=DistributionDampingFactorRotation
		Constant=(X=1.0,Y=1.0,Z=1.0)
	End Object
	DampingFactorRotation=(Distribution=DistributionDampingFactorRotation)

	Begin Object Class=DistributionFloatUniform Name=DistributionMaxCollisions
	End Object
	MaxCollisions=(Distribution=DistributionMaxCollisions)

	CollisionCompletionOption=EPCC_Kill

	bApplyPhysics=false

	Begin Object Class=DistributionFloatConstant Name=DistributionParticleMass
		Constant=0.1
	End Object
	ParticleMass=(Distribution=DistributionParticleMass)

	DirScalar=3.5
	VerticalFudgeFactor=0.1
	
	Begin Object Class=DistributionFloatConstant Name=DistributionDelayAmount
		Constant=0.0
	End Object
	DelayAmount=(Distribution=DistributionDelayAmount)

	bDropDetail=true
	LODDuplicate=false
	bPawnsDoNotDecrementCount=true
	bCollideOnlyIfVisible=true
	MaxCollisionDistance=1000.0
}
