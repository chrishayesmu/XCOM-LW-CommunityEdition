/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NxCylindricalForceFieldCapsule extends NxCylindricalForceField
	native(ForceField)
	placeable;

/** Used to preview the radius of the force. */
var()	DrawCapsuleComponent			RenderComponent;

cpptext
{
	virtual void InitRBPhys();
	virtual void TickSpecial(FLOAT DeltaSeconds);
	virtual void TermRBPhys(FRBPhysScene* Scene);

	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

#if WITH_EDITOR
	virtual void EditorApplyScale(const FVector& DeltaScale, const FMatrix& ScaleMatrix, const FVector* PivotLocation, UBOOL bAltDown, UBOOL bShiftDown, UBOOL bCtrlDown);
#endif

	virtual FPointer DefineForceFieldShapeDesc();

}

/** 
 * This is used to InitRBPhys for a dynamically spawned ForceField.
 * Used for starting RBPhsys on dyanmically spawned force fields.  This will probably need to set some transient pointer to NULL  
 **/
native function DoInitRBPhys();



defaultproperties
{

	Begin Object Class=DrawCapsuleComponent Name=DrawCapsule0
		CapsuleRadius=200.0
		CapsuleHeight=200.0
	End Object

	RenderComponent=DrawCapsule0
	Components.Add(DrawCapsule0)

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_RadForce'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="Physics"
	End Object
	Components.Add(Sprite)

	TickGroup=TG_PreAsyncWork

	ForceHeight=200.0

	RemoteRole=ROLE_SimulatedProxy
	bNoDelete=true
	bAlwaysRelevant=true
	NetUpdateFrequency=0.1
	bOnlyDirtyReplication=true
}
