/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InstancedFoliageActor extends Actor
	native(Foliage)
	hidecategories(Object);

var	const native Map_Mirror FoliageMeshes{TMap<class UStaticMesh*, struct FFoliageMeshInfo>};

/** The static mesh type that will be used to show the widget */
var const transient StaticMesh SelectedMesh;

/* Used during gameplay to simplify RTGC */
var const transient array<InstancedStaticMeshComponent> InstancedStaticMeshComponents;

cpptext
{
	// UObject interface
	virtual void Serialize(FArchive& Ar);
	virtual void PostLoad();

	// AActor interface
	virtual void UpdateComponentsInternal(UBOOL bCollisionUpdate = FALSE);
	virtual void ClearComponents();

	// AInstancedFoliageActor interface
#if WITH_EDITOR
	void SnapInstancesForLandscape( class ULandscapeHeightfieldCollisionComponent* InComponent, const FBox& InInstanceBox );
	struct FFoliageMeshInfo* AddMesh( class UStaticMesh* InMesh );
	void RemoveMesh( class UStaticMesh* InMesh );
	void SelectInstance( class UInstancedStaticMeshComponent* InComponent, INT InComponentInstanceIndex, UBOOL bToggle );
	void ApplySelectionToComponents( UBOOL bApply );
	void CheckSelection();
	FVector GetSelectionLocation();

	// Get the instanced foliage actor for the current streaming level.
	static AInstancedFoliageActor* GetInstancedFoliageActor(UBOOL bCreateIfNone=TRUE);
#endif
}

defaultproperties
{
	bStatic=true
}