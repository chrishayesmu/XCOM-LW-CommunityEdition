class XGAction_ExitCover extends XGAction
    notplaceable
    hidecategories(Navigation);

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
var private bool bWaitForAnim;
var private bool bAimOffsetSet;
var private bool bGlamCamAttempted;
var private bool bGlamCamActivated;
var private bool bInitialReplicationDataReceived_XGAction_ExitCover;
var private int UseCoverDirectionIndex;
var private XComWorldData.UnitPeekSide UsePeekSide;
var private int bCanSeeFromDefault;
var private XComAnimNodeCover UseCoverNode;
var private XComAnimNodeBlendByExitCoverType UseExitCoverNode;
var private AnimNodeSequence FinishAnimNodeSequence;
var privatewrite XComDestructibleActor WindowToBreak;
var private XComWeapon ShotWeapon;
var private float StartGlamCamTime;
var private InventoryOperation TempInvOperation;
var private repnotify repretry InitialReplicationData_XGAction_ExitCoverStruct InitialReplicationData_XGAction_ExitCover;

defaultproperties
{
    m_bBlocksInput=true
}