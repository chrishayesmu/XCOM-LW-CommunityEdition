//=============================================================================
// StaticMeshActor.
// An actor that is drawn using a static mesh(a mesh that never changes, and
// can be cached in video memory, resulting in a speed boost).
// Note that PostBeginPlay() and SetInitialState() are never called for StaticMeshActors
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class StaticMeshActor extends StaticMeshActorBase
	native
	placeable;

var() const editconst StaticMeshComponent	StaticMeshComponent;

/** If checked, this actor will not try to set its base to any proc building below it.*/
var() editoronly bool bDisableAutoBaseOnProcBuilding;

cpptext
{
	/**
	 * Function that gets called from within Map_Check to allow this actor to check itself
	 * for any potential errors and register them with map check dialog.
	 */
#if WITH_EDITOR
	virtual void CheckForErrors();
	
	/** tells this Actor to set its collision for the path building state
	 * for normally colliding Actors that AI should path through (e.g. doors) or vice versa
	 * @param bNowPathBuilding - whether we are now building paths
	 */
	virtual void SetCollisionForPathBuilding(UBOOL bNowPathBuilding);
#endif

	/** Used to parent this StaticMeshComponent to a base building's low LOD. */
	virtual void SetBase(AActor *NewBase, FVector NewFloor = FVector(0,0,1), INT bNotifyActor=1, USkeletalMeshComponent* SkelComp=NULL, FName BoneName=NAME_None );

	virtual void PostEditMove( UBOOL bFinished );

protected:
#if USE_GAMEPLAY_PROFILER
    /** 
     * This function actually does the work for the GetProfilerAssetObject and is virtual.  
     * It should only be called from GetProfilerAssetObject as GetProfilerAssetObject is safe to call on NULL object pointers
     */
	virtual UObject* GetProfilerAssetObjectInternal() const;
#endif
	/** 
	 * This function actually does the work for the GetDetailInfo and is virtual.  
	 * It should only be called from GetDetailedInfo as GetDetailedInfo is safe to call on NULL object pointers
	 */
	virtual FString GetDetailedInfoInternal() const;
}

event PreBeginPlay() {}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		bAllowApproximateOcclusion=TRUE
		bForceDirectLightMap=TRUE
		bUsePrecomputedShadows=TRUE
	End Object
	CollisionComponent=StaticMeshComponent0
	StaticMeshComponent=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)

	bDisableAutoBaseOnProcBuilding=false;
}
