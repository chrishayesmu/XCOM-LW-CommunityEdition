class XGAction_EnterCover extends XGAction;
//complete stub

enum AnimNodeConfiguration_EnterCover
{
    eANCEnterCover_Unequip,
    eANCEnterCover_EnterCover,
    eANCEnterCover_MAX
};

struct InitialReplicationData_XGAction_EnterCoverStruct
{
    var XGUnit Unit;
    var bool bUnitNone;
    var XComUnitPawn UnitPawn;
    var bool bUnitPawnNone;
    var XComUnitPawnNativeBase UnitPawnNative;
    var bool bUnitPawnNativeNone;
    var XGUnit PrimaryTarget;
    var bool bPrimaryTargetNone;
    var bool bShotNone;
    var bool bShotGrenadeAbility;
    var bool bShotGrappleAbility;
    var bool bShotStrangleAbility;
    var Vector vTarget;
};

var XGUnit Unit;
var XComUnitPawn UnitPawn;
var XComUnitPawnNativeBase UnitPawnNative;
var bool bShotNone;
var bool bShotGrenadeAbility;
var bool bShotGrappleAbility;
var bool bShotStrangleAbility;
var bool bWaitForAnim;
var bool bIsSinglePlayer;
var bool bInitialReplicationDataReceived_XGAction_EnterCover;
var XGUnit PrimaryTarget;
var Vector vTarget;
var XGAbility_Targeted m_kShot;
var XGInventoryNativeBase.ELocation m_eChangeLoc;
var XComAnimNodeBlendByExitCoverType.EExitCoverTypeToUse UseCoverType;
var XGInventoryNativeBase.ELocation EquipSlot;
var XGUnitNativeBase.ECoverState PostGrapple_CoverState;
var XComAnimNodeCover UseCoverNode;
var XComAnimNodeBlendByExitCoverType UseExitCoverNode;
var AnimNodeSequence FinishAnimNodeSequence;
var XGWeapon EquipSlot_Weapon;
var XComCoverPoint PostGrapple_CoverPointHandle;
var private InventoryOperation TempInvOperation;
var private repnotify InitialReplicationData_XGAction_EnterCoverStruct InitialReplicationData_XGAction_EnterCover;


replication
{
    if(bNetInitial && Role == ROLE_Authority)
        InitialReplicationData_XGAction_EnterCover;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit){}
function InitFromTargeting(XGAction_Fire InTargeting){}
simulated function bool ShouldCelebrate(){}
simulated function InternalCompleteAction(){}
simulated event bool IsDoneWithAbility(XGAbility kAbility){}
static final function string InitialReplicationData_XGAction_EnterCoverStruct_ToString(const out InitialReplicationData_XGAction_EnterCoverStruct kInitialReplicationData){}

simulated state Executing
{
    simulated function SetUsedAnimNodes(XGAction_EnterCover.AnimNodeConfiguration_EnterCover NodeConfiguration){}
}