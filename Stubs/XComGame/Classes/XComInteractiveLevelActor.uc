class XComInteractiveLevelActor extends XComDestructibleSkeletalMeshActor
    native(Destruction)
	dependson(XGUnitNativeBase);
//complete stub

enum EInteractionSocket
{
    XGSOCKET_None,
    XGDOOR_Inside01,
    XGDOOR_Inside02,
    XGDOOR_Inside03,
    XGDOOR_Inside04,
    XGDOOR_Inside05,
    XGDOOR_Inside06,
    XGDOOR_Outside01,
    XGDOOR_Outside02,
    XGDOOR_Outside03,
    XGDOOR_Outside04,
    XGDOOR_Outside05,
    XGDOOR_Outside06,
    XGWINDOW_Inside01,
    XGWINDOW_Inside02,
    XGWINDOW_Inside03,
    XGWINDOW_Inside04,
    XGWINDOW_Inside05,
    XGWINDOW_Inside06,
    XGWINDOW_Outside01,
    XGWINDOW_Outside02,
    XGWINDOW_Outside03,
    XGWINDOW_Outside04,
    XGWINDOW_Outside05,
    XGWINDOW_Outside06,
    XGBUTTON_01,
    XGBUTTON_02,
    XGBUTTON_03,
    XGBUTTON_04,
    EInteractionSocket_MAX
};

enum EIconSocket
{
    XGDOOR_Icon,
    XGWINDOW_Icon,
    XGBUTTON_Icon,
    EIconSocket_MAX
};

enum EInteractionAnim
{
    INTERACTION_None,
    OpenA,
    OpenB,
    CloseA,
    CloseB,
    IdleOpenA,
    IdleOpenB,
    IdleCloseA,
    IdleCloseB,
    BreakOpenA,
    BreakOpenB,
    EInteractionAnim_MAX
};

enum EInteractionPrompt
{
    Disarm,
    Activate,
    Operate,
    Hack,
    EInteractionPrompt_MAX
};

struct native SocketInteraction
{
    var() EInteractionSocket SrcSocket;
    var() const XComInteractiveLevelActor.EInteractionSocket DestSocket;
    var() const XComAnimNodeBlendByAction.EAnimAction UnitInteractionAnim;
    var() const XComAnimNodeBlendByAction.EAnimAction UnitDestroyAnim;
    var() const XComAnimNodeBlendByAction.EAnimAction UnitMovementAnim;
    var() const EInteractionAnim InteractionAnim;
    var() const EInteractionAnim DestroyAnim;
    var() const EInteractionAnim InactiveIdleAnim;
    var() const bool bMirrorAnims;
    var() const EInteractionFacing Facing;
    var const transient int DestroyAnimIndex;
    var const transient int InteractionAnimIndex;
    var const transient int InactiveIdleAnimIndex;
};

struct CheckpointRecord_XComInteractiveLevelActor extends CheckpointRecord
{
    var name ActiveSocketName;
    var bool bWasTouchActivated;
};

var() array<SocketInteraction> InteractionPoints;
var() EIconSocket IconSocket;
var() EInteractionPrompt InteractionPrompt;
var() const EInteractionAnim ActiveIdleAnim;
var() const name AnimNodeName;
var transient AnimNodeBlendList AnimNode;
var transient int ActiveIdleAnimIndex;
var transient name ActiveSocketName;
var() const bool bUseRMATranslation;
var() const bool bUseRMARotation;
var const transient bool bMustDestroy;
var bool bPlayingAnim;
var() bool bTouchActivated;
var bool bWasTouchActivated;
var init transient array<init XComInteractPoint> InteractPoints;
var() const name InteractRemoteEvent;
var() XComInteractiveLevelActorInteractionHandler InteractionHandler;
var transient int nTicks;

function bool ShouldSaveForCheckpoint(){}
function ApplyCheckpointRecord(){}

// Export UXComInteractiveLevelActor::execShouldIgnoreForCover(FFrame&, void* const)
native simulated function bool ShouldIgnoreForCover();

// Export UXComInteractiveLevelActor::execGetFacingForSocket(FFrame&, void* const)
native simulated function XGUnitNativeBase.EInteractionFacing GetFacingForSocket(name SocketName);

// Export UXComInteractiveLevelActor::execGetClosestSocket(FFrame&, void* const)
native simulated function bool GetClosestSocket(Vector InLocation, out name SocketName, out Vector SocketLocation);

// Export UXComInteractiveLevelActor::execGetSocketTransform(FFrame&, void* const)
native simulated function bool GetSocketTransform(name SocketName, out Vector SocketLocation, out Rotator SocketRotation);

// Export UXComInteractiveLevelActor::execFindChildIndex(FFrame&, void* const)
private native static final simulated function int FindChildIndex(AnimNodeBlendBase InAnimNode, name ChildName);

// Export UXComInteractiveLevelActor::execFindSocketInteraction(FFrame&, void* const)
private native final simulated function bool FindSocketInteraction(name SocketName, out SocketInteraction Interaction);

// Export UXComInteractiveLevelActor::execCacheAnimIndices(FFrame&, void* const)
private native final simulated function CacheAnimIndices();

// Export UXComInteractiveLevelActor::execCacheMustDestroy(FFrame&, void* const)
private native final simulated function CacheMustDestroy();

// Export UXComInteractiveLevelActor::execSetPrimitiveCutdownFlag(FFrame&, void* const)
native simulated function SetPrimitiveCutdownFlag(bool bShouldCutdown);

// Export UXComInteractiveLevelActor::execSetPrimitiveCutoutFlag(FFrame&, void* const)
native simulated function SetPrimitiveCutoutFlag(bool bShouldCutout);

// Export UXComInteractiveLevelActor::execSetHideableFlag(FFrame&, void* const)
native simulated function SetHideableFlag(bool bShouldHide);

// Export UXComInteractiveLevelActor::execSetPrimitiveCutdownFlagImm(FFrame&, void* const)
native simulated function SetPrimitiveCutdownFlagImm(bool bShouldCutdown);

// Export UXComInteractiveLevelActor::execSetPrimitiveCutoutFlagImm(FFrame&, void* const)
native simulated function SetPrimitiveCutoutFlagImm(bool bShouldCutout);

// Export UXComInteractiveLevelActor::execSetPrimitiveHidden(FFrame&, void* const)
native simulated function SetPrimitiveHidden(bool bInHidden);

// Export UXComInteractiveLevelActor::execSetHideableFlagImm(FFrame&, void* const)
native simulated function SetHideableFlagImm(bool bShouldHide, optional bool bAffectMainSceneChannel=true);

// Export UXComInteractiveLevelActor::execSetVisFadeFlag(FFrame&, void* const)
native simulated function SetVisFadeFlag(bool bVisFade, optional bool bForceReattach);

// Export UXComInteractiveLevelActor::execSetPrimitiveVisHeight(FFrame&, void* const)
native simulated function SetPrimitiveVisHeight(float fCutdownHeight, float fCutoutHeight, float fOpacityMaskHeight, float fPreviousOpacityMaskHeight);

// Export UXComInteractiveLevelActor::execSetPrimitiveVisFadeValues(FFrame&, void* const)
native simulated function SetPrimitiveVisFadeValues(float CutoutFade, float TargetCutoutFade);

// Export UXComInteractiveLevelActor::execCanUseCutout(FFrame&, void* const)
native simulated function bool CanUseCutout();

// Export UXComInteractiveLevelActor::execChangeVisibilityAndHide(FFrame&, void* const)
native simulated function ChangeVisibilityAndHide(bool bShow, float fCutdownHeight, float fCutoutHeight);

// Export UXComInteractiveLevelActor::execSetLightEnvironment(FFrame&, void* const)
native final function SetLightEnvironment();

// Export UXComInteractiveLevelActor::execIsDoor(FFrame&, void* const)
native simulated function bool IsDoor();

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){}
simulated event PostBeginPlay(){}
simulated event PreBeginPlay(){}
simulated function AddInteractionPoint(SocketInteraction kInteractionPoint){}
simulated function bool Interact(XGUnit InUnit, name SocketName){}
function OnLoadInteract(){}
simulated function AddActionsToUnit(XGUnit InUnit, name SocketName){}
simulated function Kismet_OnInteract(XGUnit InUnit){}
simulated function OnDisableInteractiveActor(){}
simulated function OnEnableInteractiveActor(){}
simulated function BreakInteractActor(name SocketName){}
function DeferredRebuildTileData(){}
simulated function PlayAnimations(XGUnit InUnit, name SocketName);

simulated function bool IsAnimating(){}
simulated function bool CanInteract(XGUnit InUnit, name SocketName){}
simulated function BeginInteraction(XGUnit InUnit, name SocketName);
simulated function EndInteraction(XGUnit InUnit, name SocketName);
simulated function string GetActionString(XGUnit InUnit){}

simulated state _Pristine
{
	simulated event BeginState(name PreviousStateName);
	simulated event EndState(name NextStateName);
	simulated event Tick(float DeltaTime){}
	simulated function bool CanInteract(XGUnit InUnit, name SocketName){}
	simulated function BeginInteraction(XGUnit InUnit, name SocketName){}
	simulated function EndInteraction(XGUnit InUnit, name SocketName){}
	simulated function string GetActionString(XGUnit InUnit){}
	event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal){}
	simulated function PlayAnimations(XGUnit InUnit, name SocketName){}
}

simulated state _Inactive extends _Pristine
{
	simulated event BeginState(name PreviousStateName);
	simulated function bool CanInteract(XGUnit InUnit, name SocketName)
	{
		return false;
	}
	simulated function BeginInteraction(XGUnit InUnit, name SocketName);
	simulated function EndInteraction(XGUnit InUnit, name SocketName);
	simulated function string GetActionString(XGUnit InUnit)
	{
		return "UNKNOWN";
	}
	simulated function SwitchToInactiveAnimation(){}
}