class XGAction_Targeting extends XGAction_Idle
    native(Action);
//complete stub

var const localized string m_strTargetNameEnemy;
var const localized string m_strTargetNameFriend;
var const localized string m_strTargetNameCivilian;
var const localized string m_sShotHasTarget;
var const localized string m_sShotHasTargets;
var XGUnit m_kInitialUnitTarget;
var XGUnit m_kFireOnlyAtThisUnit;
var bool m_bMustPerformAction;
var bool m_bTargetMustBeWithinCursorRange;
var bool m_bOnlyFireAtLocation;
var bool m_bResetTraceValues;
var bool m_bBullRushValid;
var bool m_bLastTileValid;
var bool m_bSetShotDisabled;
var bool m_bPleaseHitFriendlies;
var bool m_bShotSetViaLocalPlayerInput;
var bool m_bShotIsBlocked;
var bool bClusterBombSetup;
var bool bClusterBombFiring;
var bool m_bForceOverheadCamera;
var bool m_bUnitIsActive;
var bool m_bCanceled;
var bool bForceHit;
var bool bForceMiss;
var bool m_bFired;
var float m_fAllowedCursorRange;
var Vector m_vFireOnlyAtThisLocation;
var ParticleSystem m_DiscPreview;
var transient XComEmitter ExplosionEmitter;
var transient DynamicSMActor_Spawnable VisualizerActor;
var transient EAbility ExplosionEmitterType;
var ParticleSystem m_blastPreview;
var array<XGUnit> m_arrInteractionList_Total;
var array<XGUnit> m_arrInteractionList_ConstrainedByAbilities;
var int m_iLastTileIndexTrace;
var Vector m_vTraceOrigin;
var Vector m_vTraceDir;
var repnotify Vector m_vReplicatedBullRushHitNormal;
var Vector m_vSplashCenterCache;
var float m_fSplashRadiusCache;
var int m_iSplashHitsFriendliesCache;
var int m_iSplashHitsFriendlyDestructibleCache;
var repnotify XGAbility_Targeted m_kReplicatedShot;
var XGUnit m_kTargetedEnemy;
var repnotify Vector m_vTarget;
var repnotify Actor TargetActor;
var XGAbility_Targeted m_kShot;
var XGCameraView m_kAimingView;
var Vector m_vHitLocation;
var array<Actor> m_arrMarkedTargets;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_kReplicatedShot;

    if((!bNetOwner && bNetDirty) && Role == ROLE_Authority)
        TargetActor, m_vReplicatedBullRushHitNormal, 
        m_vTarget, m_vTraceDir, 
        m_vTraceOrigin;
}

native simulated function ClearTargetedActors();
native simulated function MarkTargetedActors(out array<Actor> Actors);
native simulated function UpdateShotTargetLocation(Vector vCenter, float fRadius);
native static simulated function GetTargetedActors(Vector vCenter, float fRadius, XGAbility_Targeted kShot, out array<Actor> Actors);

simulated event ReplicatedEvent(name VarName){}
function bool Init(XGUnit kUnit){}
simulated function bool CanBePerformed(){}
simulated event SimulatedInit(){}
simulated function UpdateAimingView(){}
simulated function InternalCompleteAction(){}
simulated function SetOnlyUseOverheadCamera(bool isForcingOverheadCameraOnly){}
reliable server function ServerSetOnlyUseOverheadCamera(bool isForcingOverheadCameraOnly){}
simulated function SwitchToOverheadMode(XGUnit kUnit){}
simulated function SetInitialUnitTarget(XGUnit kUnit){}
simulated function XGUnit GetInitialUnitTarget(){}
simulated function SetTargetedEnemy(XGUnit kTargetedEnemy){}
reliable server function ServerSetTargetedEnemy(XGUnit kTargetedEnemy){}
simulated function bool MustPerformAction(){}
simulated function OnTurnTimerExpired(){}
simulated function bool Cancel(bool bCalledFromLocalUI){}
reliable server function ServerCancel(){}
simulated function bool InitializeAbilityToTargetedUnit(XGUnit kTargetUnit){}
simulated function XGUnit GetUnitTarget(){}
simulated function XComUnitPawn GetTargetPawn(){}
simulated function ClearFlameThrowerUI(){}
simulated function bool NextTarget();

simulated function bool PrevTarget();

simulated function int GetIndexOfNextTarget();

simulated function int GetIndexOfPrevTarget();

simulated function FreeAim();

simulated function bool IsLockedOnTarget();

simulated function Vector2D GetTargetCursorPos();

simulated function PopulateTargets(XGAbility_Targeted kShot){}
simulated function Vector GetHitLocation(){}
simulated function TraceToTarget(){}
simulated function bool TraceToTarget_BullRush(Vector vHitNormal){}
simulated function bool TraceToTarget_XComUnitPawn(){}
simulated function bool TraceToTarget_DestroyCover(){}
simulated function bool GetMaterialTextString(out string strHelpMsg, Actor KActor, out Vector vLoc){}
simulated function UpdateLastTile(bool bValid){}
simulated function bool IsTargetOnSameTile(){}
simulated function XGUnit GetUnitBehindWall(Vector vDest){}
simulated function SetTraceValues(Vector AimStart, Vector AimDir){}
reliable server function ServerSetTraceValues(Vector vAimStart, Vector vAimDir){}
reliable server function ServerSetBullRushTargetInfo(Vector vBullRushHitNormal, Vector vBullRushToTarget, Actor kBullRushTargetActor){}
simulated function ActivateProjectileTrajectoryPreview(float dt){}
simulated function GetUIHitChance(out int iUIHitChance, out int iUICriticalChance){}
reliable server function ServerFire(Vector vTraceOrigin, Vector vTraceDir, Vector vTargetLoc, Actor kTargetActor, bool bIsFreeAiming){}
simulated function bool FireShot(XGAbility_Targeted kShot){}
function ExecuteShot(){}
simulated function SetShot(XGAbility_Targeted kShot, bool bSetViaLocalPlayerInput, optional bool bForceOverride){}
simulated function RestoreCursor(){}
simulated function SetStates(){}
simulated function SetControllerState(optional bool bPlayerAiming){}
simulated function bool AbilityIgnoresTargetedUnit(EAbility EAbilityType){}
reliable server function ServerSetTargetAbility(XGAbility_Targeted kTarget){}
simulated function bool IsShotBlocked(){}
simulated function bool IsFreeAiming(){}
simulated function SetUnitTarget(XGUnitNativeBase kTarget){}
simulated function Vector GetTargetLoc(){}
simulated function MoveCursor(XGUnit kUnitToMoveTo, optional EAbility eInputAbilityType){}
simulated function bool SetChainedDistance(EAbility eInputAbilityType, optional out float fMinDistance){}
simulated function bool AbilityRequiresChainedDistance(EAbility EAbilityType){}
simulated function SetTargetForPawn(Vector vTarget){}
reliable server function ServerSetTargetForPawn(Vector vTarget){}
simulated function SetTargetLoc(Vector vTargetLoc){}
simulated function SetTargetActor(Actor kTargetActor){}
reliable server function ServerSetTargetActor(Actor kTargetActor){}
unreliable server function ServerSetTargetLoc(Vector vTargetLoc){}
simulated function XGCameraView GetCurrentView(){}
simulated function bool InternalIsInterruptibleBy(class<XGAction> kActionClass){}
simulated event Destroyed(){}

simulated state Executing
{
    simulated event BeginState(name P){}
    simulated event EndState(name NextStateName){}
    simulated function LookAtTargetedEnemy(){}
    simulated event Tick(float dt){}
    simulated function CheckForShotBlocked(){}
    simulated function DrawClusterBombTargeting(){}
    simulated function DrawSplashRadius(){}
    simulated function DrawFlameThrowerUI(){}
    simulated function DrawKineticStrikeUI(){}
    simulated function DrawVolume(){}
    simulated function bool IsLockedOnTarget(){}
    simulated function Vector2D GetTargetCursorPos(){}
    simulated function bool NextTarget(){}
    simulated function int GetIndexOfNextTarget(){}
    simulated function bool PrevTarget(){}
    simulated function int GetIndexOfPrevTarget(){}
    simulated function RealizeNewTarget(){}
    simulated function FreeAim(){}
}
