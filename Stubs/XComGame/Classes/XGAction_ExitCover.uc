class XGAction_ExitCover extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub
	
enum AnimNodeConfiguration
{
    eConfig_Unequip,
    eConfig_ExitCover,
    eConfig_MAX
};

struct InitialReplicationData_XGAction_ExitCoverStruct
{
    var XGUnit Unit;
    var bool bUnitNone;
    var XComUnitPawn UnitPawn;
    var bool bUnitPawnNone;
    var XGUnit PrimaryTarget;
    var bool bPrimaryTargetNone;
    var XGAbility_Targeted m_kShot;
    var bool m_bShotNone;
    var Vector m_vTarget;
    var int NumShots;
    var FiringStateReplicationData m_arrFiringStateRepDatas[EXGAbilityNumTargets];
};

var XGUnit Unit;
var XComUnitPawn UnitPawn;
var XGUnit PrimaryTarget;
var XGAbility_Targeted m_kShot;
var Vector m_vTarget;
var bool bShotGrappleAbility;
var bool bWaitForAnim;
var bool bAimOffsetSet;
var bool bGlamCamAttempted;
var bool bGlamCamActivated;
var bool bInitialReplicationDataReceived_XGAction_ExitCover;
var int UseCoverDirectionIndex;
var UnitPeekSide UsePeekSide;
var int bCanSeeFromDefault;
var XComAnimNodeCover UseCoverNode;
var XComAnimNodeBlendByExitCoverType UseExitCoverNode;
var AnimNodeSequence FinishAnimNodeSequence;
var XComDestructibleActor WindowToBreak;
var XComWeapon ShotWeapon;
var float StartGlamCamTime;
var InventoryOperation TempInvOperation;
var repnotify InitialReplicationData_XGAction_ExitCoverStruct InitialReplicationData_XGAction_ExitCover;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        InitialReplicationData_XGAction_ExitCover;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function bool FiringStateReplicationDatasArray_IsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit){}
function InitFromTargeting(XGAction_Fire InTargeting){}
simulated function bool NeedToChangeWeapons(){}
simulated function bool NeedToChangeWeaponsOnSetShot(){}
simulated function bool AllowGlamCam(){}
simulated event bool IsDoneWithAbility(XGAbility kAbility){}
static final function string InitialReplicationData_XGAction_ExitCoverStruct_ToString(const out InitialReplicationData_XGAction_ExitCoverStruct kRepInfo){}

simulated state Executing
{
    simulated function SetUsedAnimNodes(AnimNodeConfiguration NodeConfiguration, float BlendTime){}
	function bool UnitFacingMatchesDesiredDirection(){}
    simulated event Tick(float DeltaT){}
}
