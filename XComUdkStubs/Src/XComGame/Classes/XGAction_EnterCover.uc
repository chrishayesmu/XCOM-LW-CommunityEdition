class XGAction_EnterCover extends XGAction
    notplaceable
    hidecategories(Navigation);

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
var private bool bInitialReplicationDataReceived_XGAction_EnterCover;
var XGUnit PrimaryTarget;
var Vector vTarget;
var XGAbility_Targeted m_kShot;
var ELocation m_eChangeLoc;
var EExitCoverTypeToUse UseCoverType;
var ELocation EquipSlot;
var XGUnitNativeBase.ECoverState PostGrapple_CoverState;
var XComAnimNodeCover UseCoverNode;
var XComAnimNodeBlendByExitCoverType UseExitCoverNode;
var AnimNodeSequence FinishAnimNodeSequence;
var XGWeapon EquipSlot_Weapon;
var XComCoverPoint PostGrapple_CoverPointHandle;
var private InventoryOperation TempInvOperation;
var private repnotify repretry InitialReplicationData_XGAction_EnterCoverStruct InitialReplicationData_XGAction_EnterCover;

defaultproperties
{
    m_bBlocksInput=true
}