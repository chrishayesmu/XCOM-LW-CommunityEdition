class XComInteractiveLevelActor extends XComDestructibleSkeletalMeshActor
    native(Destruction)
    dependson(XGUnitNativeBase)
    hidecategories(Navigation);

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
    var() const EInteractionSocket DestSocket;
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

    structdefaultproperties
    {
        InteractionAnimIndex=-1
        InactiveIdleAnimIndex=-1
    }
};

struct CheckpointRecord_XComInteractiveLevelActor extends CheckpointRecord
{
    var name ActiveSocketName;
    var bool bWasTouchActivated;
};

var() privatewrite array<SocketInteraction> InteractionPoints;
var() EIconSocket IconSocket;
var() EInteractionPrompt InteractionPrompt;
var() const EInteractionAnim ActiveIdleAnim;
var() const name AnimNodeName;
var privatewrite transient AnimNodeBlendList AnimNode;
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

defaultproperties
{
    AnimNodeName=Anim
    ActiveIdleAnimIndex=-1
    bUseRMATranslation=true
    bUseRMARotation=true
    bInteractive=true
    bTickIsDisabled=false

    begin object name=MyNEWLightEnvironment
        bUseBooleanEnvironmentShadowing=true
        bSynthesizeDirectionalLight=false
        bSynthesizeSHLight=true
        bDoorOrWindow=true
        bEnabled=true
    end object
}