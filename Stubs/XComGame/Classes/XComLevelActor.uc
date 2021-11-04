class XComLevelActor extends StaticMeshActor
    native(Level)
    hidecategories(Navigation)
    implements(XComCoverInterface,IMouseInteractionInterface);
//complete stub

struct native VisibilityBlocking
{
    var() const bool bBlockUnitVisibility;
};

//var private native const noexport Pointer VfTable_IXComCoverInterface;
var() const editconst export editinline XComFloorComponent FloorComponent;
var() VisibilityBlocking VisibilityBlockingData;
var() const bool HideableWhenBlockingObjectOfInterest;
var() const bool bIgnoreFor3DCursorCollision;
var(Cover) bool bAlwaysConsiderForCover;
var(Cover) bool bCanClimbOver;
var(Cover) bool bCanClimbOnto;
var(Cover) bool bIsValidDestination;
var(Cover) bool bIgnoreForCover;
var(Cover) bool bUseRigidBodyCollisionForCover;
var() LinearColor TintColor;
var() Actor HidingPartner;
var(Cover) ECoverForceFlag CoverForceFlag;
var(Cover) ECoverForceFlag CoverIgnoreFlag;

// Export UXComLevelActor::execIsPositionVisible(FFrame&, void* const)
native function bool IsPositionVisible(const out Vector Position, out int bCutout, PrimitiveComponent HitComp);

// Export UXComLevelActor::execConsiderForOccupancy(FFrame&, void* const)
native simulated function bool ConsiderForOccupancy();

// Export UXComLevelActor::execShouldIgnoreForCover(FFrame&, void* const)
native simulated function bool ShouldIgnoreForCover();

// Export UXComLevelActor::execUseRigidBodyCollisionForCover(FFrame&, void* const)
native simulated function bool UseRigidBodyCollisionForCover();

// Export UXComLevelActor::execCanClimbOver(FFrame&, void* const)
native simulated function bool CanClimbOver();

// Export UXComLevelActor::execCanClimbOnto(FFrame&, void* const)
native simulated function bool CanClimbOnto();

// Export UXComLevelActor::execGetCoverForceFlag(FFrame&, void* const)
native simulated function XComCoverInterface.ECoverForceFlag GetCoverForceFlag();

// Export UXComLevelActor::execGetCoverIgnoreFlag(FFrame&, void* const)
native simulated function XComCoverInterface.ECoverForceFlag GetCoverIgnoreFlag();

// Export UXComLevelActor::execSetPrimitiveCutdownFlag(FFrame&, void* const)
native simulated function SetPrimitiveCutdownFlag(bool bShouldCutdown);

// Export UXComLevelActor::execSetPrimitiveCutoutFlag(FFrame&, void* const)
native simulated function SetPrimitiveCutoutFlag(bool bShouldCutout);

// Export UXComLevelActor::execSetPrimitiveCutdownFlagImm(FFrame&, void* const)
native simulated function SetPrimitiveCutdownFlagImm(bool bShouldCutdown);

// Export UXComLevelActor::execSetPrimitiveCutoutFlagImm(FFrame&, void* const)
native simulated function SetPrimitiveCutoutFlagImm(bool bShouldCutout);

// Export UXComLevelActor::execSetPrimitiveHidden(FFrame&, void* const)
native simulated function SetPrimitiveHidden(bool bInHidden);

// Export UXComLevelActor::execSetVisFadeFlag(FFrame&, void* const)
native simulated function SetVisFadeFlag(bool bVisFade, optional bool bForceReattach);
// Export UXComLevelActor::execGetPrimitiveVisHeight(FFrame&, void* const)
native simulated function GetPrimitiveVisHeight(out float fCutdownHeight, out float fCutoutHeight, out float fOpacityMaskHeight, out float fPreviousOpacityMaskHeight);

// Export UXComLevelActor::execSetPrimitiveVisHeight(FFrame&, void* const)
native simulated function SetPrimitiveVisHeight(float fCutdownHeight, float fCutoutHeight, float fOpacityMaskHeight, float fPreviousOpacityMaskHeight);

// Export UXComLevelActor::execGetPrimitiveVisFadeValues(FFrame&, void* const)
native simulated function GetPrimitiveVisFadeValues(out float CutoutFade, out float TargetCutoutFade);

// Export UXComLevelActor::execSetPrimitiveVisFadeValues(FFrame&, void* const)
native simulated function SetPrimitiveVisFadeValues(float CutoutFade, float TargetCutoutFade);

// Export UXComLevelActor::execCanUseCutout(FFrame&, void* const)
native simulated function bool CanUseCutout();

// Export UXComLevelActor::execSetHideableFlag(FFrame&, void* const)
native simulated function SetHideableFlag(bool bShouldHide);

// Export UXComLevelActor::execSetHideableFlagImm(FFrame&, void* const)
native simulated function SetHideableFlagImm(bool bShouldHide, optional bool bAffectMainSceneChannel=true);

// Export UXComLevelActor::execCanUseHideable(FFrame&, void* const)
native simulated function bool CanUseHideable();

// Export UXComLevelActor::execChangeVisibilityAndHide(FFrame&, void* const)
native simulated function ChangeVisibilityAndHide(bool bShow, float fCutdownHeight, float fCutoutHeight);

// Export UXComLevelActor::execChangeVisibility(FFrame&, void* const)
native simulated function ChangeVisibility(float fCutdown, float fCutoutHeight);

// Export UXComLevelActor::execGetHidingPartner(FFrame&, void* const)
native simulated function Actor GetHidingPartner();

// Export UXComLevelActor::execUpdateTintColor(FFrame&, void* const)
native simulated function UpdateTintColor();

simulated event PostBeginPlay(){}
simulated event Tick(float DeltaTime){}
function bool OnMouseEvent(int Cmd, int Actionmask, optional Vector MouseWorldOrigin, optional Vector MouseWorldDirection, optional Vector HitLocation){}
function OnSetMaterial(SeqAct_SetMaterial Action){}
