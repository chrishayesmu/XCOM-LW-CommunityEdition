class XGAction_Fire extends XGAction
    native(Action)
	implements(DamageDealingAction)
dependson(XComAnimNodeWeapon)
dependson(XGUnitNativeBase)
dependson(XComGameReplicationInfo)
dependson(XComAnimNodeBlendByAction);

//complete stub

enum EFireActionStatus
{
    EFAS_None,
    EFAS_Camera,
    EFAS_ConstantCombat,
    EFAS_Overwatch1,
    EFAS_Turning1,
    EFAS_Turning2,
    EFAS_SpecialAbility,
    EFAS_SpecialAnim,
    EFAS_Melee,
    EFAS_Firing_Wait,
    EFAS_Overwatch,
    EFAS_Overmind,
    EFAS_PodMgr,
    EFAS_DoneFiring,
    EFAS_NextShotBegin,
    EFAS_AdrenalNeurosympathy,
    EFAS_ShutDownToIdle,
    EFAS_MAX
};

enum ECustomFireActionType
{
    CustomFireActionType_None,
    CustomFireActionType_LegacyMelee,
    CustomFireActionType_Flamethrower,
    CustomFireActionType_KineticStrike,
    CustomFireActionType_Barrage,
    CustomFireActionType_MAX
};

struct native FiringStateReplicationData_WaitOnExecutingShotAbility
{
    var bool m_bWaitOnShotAbility;
    var bool m_bReplicateFlipFlop;
};
struct native GrappleStateReplicationData
{
    var Vector m_vGrappleLedgePoint;
    var Vector m_vGrappleLedgeNormal;
    var bool m_bGrappleShouldClimbOverLedge;
    var bool m_bGrappleReplicateFlipFlop;
};

struct native InitialReplicationData_XGAction_Fire
{
    var XComFiredProjectileList m_kFiredProjectileList;
    var bool m_bFiredProjectileListNone;
    var bool m_bForceOverheadCamera;
    var XGUnit m_kTargetedEnemy;
    var bool m_bTargetedEnemyNone;
    var Vector m_vTarget;
    var Actor m_kTargetActor;
    var bool m_bTargetActorNone;
    var XGAbility_Targeted m_kShot;
    var bool m_bShotNone;
    var bool m_bShotIsBlocked;
    var bool m_bClusterBombSetup;
    var bool m_bClusterBombFiring;
    var bool m_bHasAdrenalNeurosympathy;
    var bool m_bAdrenalNeurosympathyOnCooldown;
    var bool m_bGrappleIsValid;
    var Vector m_vHitLocation;
    var int NumShots;
    var FiringStateReplicationData m_arrFiringStateRepDatas[EXGAbilityNumTargets];
    var bool m_bHumanTargeted;
    var Vector m_vHumanTargetedLocation;
    var XGUnit m_kStrangleTarget;
    var bool m_bStrangleTargetNone;
};

var const localized string m_sTargetMissDamageDisplay;
var const localized string m_sTracerBeamDamageDisplay;
var const localized string m_sChitinPlatingDamageDisplay;
var const localized string m_sCombatStimesDamageDisplay;
var bool m_bWeaponWasFired;
var bool m_bShotIsBlocked;
var bool m_bForceOverheadCamera;
var bool m_bHumanTargeted;
var bool m_bExitedCover;
var bool m_bFireActionDoEarlyCC;
var bool m_bStartEarlyFireActionCC;
var bool m_bExecutedAbility;
var bool bForceHit;
var bool bForceMiss;
var bool bDidGlamCamCheck;
var bool m_bFiringStateRepDataReceived_WaitOnExecutingShotAbility;
var bool m_bGlamCamActive;
var bool m_bCameraIsFinished;
var bool m_bCameraIsReady;
var bool m_bDebugEmergencyAbort;
var bool m_bStartedStateFiring;
var bool m_bBottomOfExecutingState;
var bool m_bUpdateAnimRot;
var bool m_bUseAimAtTargetMissPercentage;
var bool m_bIsInterruptible;
var bool m_bDemoEndingDone;
var bool m_bUnitIsActive;
var transient bool m_bWaitingForOverwatchToComplete;
var transient bool m_bGrappleShouldClimbOverLedge;
var transient bool m_bGrappleIsValid;
var transient bool m_bGrappled;
var bool m_bGrappleStateDataReplicated;
var bool m_bAttackerVisibleToEnemy;
var bool m_bProjectileWillBeVisibleToEnemy;
var bool m_bInitialReplicationDataReceived_XGAction_Fire;
var bool m_bReplicateShot;
var bool m_bDisableShotReplicationWhenFiring;
var bool m_bClientShotFinishedExecution;
var bool m_bNotifyExecutedShot;
var bool m_bHasAdrenalNeurosympathy;
var bool m_bAdrenalNeurosympathyOnCooldown;
var bool m_bFiringPanDone;
var bool bClusterBombSetup;
var bool bClusterBombFiring;
var bool m_bTriggeredReflection;
var bool bMutonBeatDownGlamCam;
var bool bMutonBeatUpGlamCam;
var bool bChryssalidBiteGlamCam;
var bool bSpokeAboutMiss;
var bool m_bClientStopWaitingForFiringStateShotAbility;
var Actor TargetActor;
var Vector m_vTarget;
var float fPreviewTimer;
var XGWeapon m_kWeapon;
var array<XGUnit> m_arrVictims;
var XGUnit m_kTargetedEnemy;
var XGAbility_Targeted m_kShot;
var Vector m_vHumanTargetedLocation;
var int CurrentShotIndex;
var FiringStateReplicationData CurrentShotReplicationData;
var int m_iTracerBeamShots;
var float m_fExtraSleepTimePostShutdown;
var repnotify FiringStateReplicationData_WaitOnExecutingShotAbility m_kFiringStateRepData_WaitOnExecutingShotAbility;
var XGCameraView m_kSavedView;
var XGCameraView m_kAimingView;
var XGCameraView_Firing m_kFiringView;
var XGCameraView_Midpoint m_kMidpointView;
var XComProjectile m_arrProjectiles[32];
var int m_numProjectiles;
var XGUnitNativeBase.ECoverState m_eStoredCoverState;
var transient XComAnimNodeBlendByAction.EAnimAction m_TmpAnimActionIndex;
var transient XComGameReplicationInfo.ESingleAnim m_TmpSingleAnim;
var EFireActionStatus m_eFireActionStatus;
var ECustomFireActionType CustomFireActionType;
var Vector m_StoredLocation;
var Vector m_vStoredFinalExitCoverDir;
var int m_iAimingIterations;
var transient float m_fTurnTimer;
var transient AnimNodeBlendList m_TmpBlendList;
var transient AnimNodeSequence m_TmpNode;
var transient AnimNodeSequence m_TmpNode2;
var transient Vector2D m_TmpAimOffset;
var transient float m_fTemp;
var transient float m_fTemp2;
var transient float m_fTemp3;
var transient XGUnit m_kShutDownToIdle_WaitingOn_BusyUnit;
var XComDestructibleActor WindowToBreak;
var int m_tempMovementNodeIndex;
var int m_tempActionNodeIndex;
var transient float m_fGrappleDistance;
var transient float m_fGrappleTravelTimer;
var transient float m_fGrappleTravelTime;
var transient float m_fGrappleAlpha;
var transient Vector m_vGrappleDirection;
var transient Vector m_vGrappleOriginalLoc;
var transient Vector m_vGrappleLedgePoint;
var transient Vector m_vGrappleLedgeNormal;
var float m_fHangBreakoutTime;
var repnotify GrappleStateReplicationData m_kGrappleStateRepData;
var int m_iNumProjectileOnDealDamageCalls;
var int m_iNumProjectileMissCalls;
var transient Vector vSelectedTargetLocation;
var XComFiredProjectileList m_kFiredProjectileList;
var repnotify InitialReplicationData_XGAction_Fire m_kInitialReplicationData_XGAction_Fire;
var int m_iNumTimesFired;
var Actor CustomFireActor;
var Vector m_vHitLocation;


replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_bClientStopWaitingForFiringStateShotAbility, m_kFiringStateRepData_WaitOnExecutingShotAbility, 
        	m_kGrappleStateRepData;
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Fire;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function bool FiringStateReplicationDatasArray_IsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit){}
function InitFromTargeting(XGAction_Targeting kTargeting){}
function InitFiringStateReplicationData(){}
simulated event SimulatedInit(){}
simulated function XGCameraView GetCurrentView(){}
simulated function bool IsThirdPersonAiming(){}
simulated function bool IsFreeAiming(){}
simulated function bool IsFiringStateDataReplicated_WaitOnExecutingShotAbility(){}
simulated function bool IsHit(){}
simulated function bool IsCritical(){}
simulated function bool IsKillShot(){}
simulated function bool IsReflected(){}
simulated function bool CanApplyTracerBeamFX(){}
simulated function bool IsInLowCover(XGUnit kUnit){}
simulated function SetUnitTarget(XGUnitNativeBase kTarget){}
simulated function int GetTimeCost(){}
simulated function bool CanBePerformed(){}
function AddVictim(XGUnit kUnit){}
simulated function XComUnitPawn GetTargetPawn(){}
simulated function bool GetTargetCoverLocation(optional out XComCoverPoint Point){}
simulated function Vector GetTargetLoc(){}
simulated function SetTargetLoc(Vector vTargetLoc){}
unreliable server function ServerSetTargetLoc(Vector vTargetLoc){}
simulated function SetTargetActor(Actor kTargetActor){}
reliable server function ServerSetTargetActor(Actor kTargetActor){}
simulated function SetTargetForPawn(Vector vTarget){}
reliable server function ServerSetTargetForPawn(Vector vTarget){}
simulated function float GetMinWeaponFiringDistance(){}
simulated function RestoreCursor(){}
simulated function Vector GetWeaponPosition(){}
simulated function Rotator GetWeaponRotation(){}
simulated function XGUnit GetUnitTarget(){}
simulated function UpdateAnimationRotation(float dt){}
simulated function bool InternalIsInterruptibleBy(class<XGAction> kActionClass){}
simulated function GotoStateFiring(){}
simulated function bool CanGotoFiringState(){}
simulated function GotoStateShutDownToIdle(){}
simulated function Vector GetActualFireActionTargetLocation(){}
simulated function bool DoGlamCam(){}
simulated function InitMultiShot(){}
simulated function UninitMultiShot(){}
simulated function FireDisablingShot(){}
reliable server function ServerSetState(name StateName){}
simulated function Vector NonUnitTargetAdjustedForMiss(){}
simulated function Vector TargetAdjustedForMiss(){}
simulated function AddProjectile(XComProjectile kProjectile){}
simulated function RemoveProjectile(XComProjectile kProjectile){}
simulated function TriggerProjectileImpacts(){}
simulated function bool CanAddProjectile(){}
simulated function CommenceFiring();
simulated function CameraIsDone();
simulated function UseChangeWeaponCam(){}
simulated function DoFireUponUnitEvent(){}
simulated function string GetDebugHangLog(){}
simulated function Abort(){}
simulated function int CalcDamage(){}
simulated function bool IsCurrentAbilityGrapple(){}
simulated function bool IsCurrentWeaponGrenade(){}
simulated function bool IsCurrentWeaponGrapple(){}
simulated function ExecuteShotAbility(){}
simulated function SetWeaponAnimNode(EAnimWeapon Anim){}
simulated function XGUnit GetTargetUnit(){}
simulated function SwitchToOverheadMode(XGUnit kUnit){}
simulated function SetOnlyUseOverheadCamera(bool isForcingOverheadCameraOnly){}
simulated function UpdateAimingView(XGAction_Targeting kTargeting){}
simulated function bool IsValidTargetBusyPostFiring(){}
simulated function InternalCancel(){}
simulated function Terminate(){}
simulated function InternalCompleteAction(){}
function XGUnit GetValidEnemyTargetForReactionFire(){}
simulated function ActivateProjectileTrajectoryPreviewForAI(float dt){}
simulated function ForceHit(){}
simulated function bool HasMultipleTargets(out array<XGUnit> arrTarget_out){}
simulated function bool Projectile_OverrideStartPositionAndDir(out Vector tempTrace, out Vector tempDir){}
simulated function GetProjectileDamage(bool bCanDoDamage, XComProjectile kProjectile, XComWeapon kWeapon, out XComUnitPawn kTargetPawn, out XGUnitNativeBase kTargetUnit, out int iDamageAmount, out int iWorldDamage){}
simulated event Destroyed(){}
simulated function MarkOrDestroyView(XGCameraView kView){}
simulated function Projectile_OnInit(XComProjectile kProjectile){}
simulated function Projectile_OnShutdown(XComProjectile kProjectile){}
simulated function Projectile_OnDealDamage(XComProjectile kProjectile){}
simulated function bool CanDisplayDamageMessage(){}
simulated function bool WeaponWasFired(){}
simulated event bool IsDoneWithAbility(XGAbility kAbility){}
static final function string InitialReplicationData_XGAction_Fire_ToString(const out InitialReplicationData_XGAction_Fire kRepInfo){}

simulated state Executing
{}
simulated state SwitchingWeapons
{
    simulated function Setup_UnEquip(){}
    simulated function Setup_Equip(){}
}
simulated state Firing
{
simulated function SetTraceValues(Vector AimStart, Vector AimDir){};
    simulated function LookAtFiringUnit(){}
    simulated function SetupFiringPanToEnemy(){}
    simulated event BeginState(name PreviousStateName){}
    simulated function ChooseFiringCam(){}
    simulated function SetTargetForFiring(){}
    simulated function FireWeapon(){}
    simulated function bool UseSpecialAbility(out EAnimAction animActionToUse){}
    simulated function bool UseSpecialAnim(out ESingleAnim animToUse){}
    simulated function bool CanAddProjectile(){}
    simulated function CommenceFiring(){}
    simulated function CameraIsDone(){}
    simulated event Tick(float fDeltaT){}

    simulated function DebugProjectiles(){}
    simulated function ECustomFireActionType CheckForCustomFireAction(){}
}
simulated state Grappling
{}

simulated state ShutDownToIdle
{
    simulated event BeginState(name PreviousStateName){}
    simulated event bool IsShuttingDown(){}
    simulated function bool AllowShutDownToIdle(){}
}
