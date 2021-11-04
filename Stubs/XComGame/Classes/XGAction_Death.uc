class XGAction_Death extends XGAction
    notplaceable
    hidecategories(Navigation)
    implements(DamageDealingAction);
//complete stub

const HACK_MAX_GHETTO_DEATH_STUCK_LOOPING_TIMEOUT_SECONDS = 5.0f;

enum EDeathActionStatus
{
    EDAS_None,
    EDAS_Begin,
    EDAS_MindMergeDeath,
    EDAS_KineticStrike,
    EDAS_ExaltSuicide,
    EDAS_Strangling,
    EDAS_Strangled,
    EDAS_CustomNotifies,
    EDAS_Ragdoll,
    EDAS_DeathAnim,
    EDAS_Overmind,
    EDAS_PodUpdate,
    EDAS_ReactionFire,
    EDAS_WhiplashLoop,
    EDAS_Done,
    EDAS_MAX
};

struct native InitialReplicationData_XGAction_Death
{
    var XGUnitNativeBase m_kDamageDealer;
    var bool m_bDamageDealerNone;
    var Actor m_kDamageCauser;
    var bool m_bDamageCauserNone;
    var int m_iDamage;
    var class<DamageType> m_kDamageType;
    var Vector m_vHitLocation;
    var Vector m_vMomentum;
    var Weapon m_kDroppedWeapon;
    var bool m_bDroppedWeaponNone;
    var XComPawn m_kCachedPawn;
    var bool m_bCachedPawnNone;
};

var XGUnit m_kDamageDealer;
var Actor m_kDamageCauser;
var XComProjectile m_kDamageCauserProjectile;
var int m_iDamage;
var class<DamageType> m_kDamageType;
var class<XComDamageType> m_kXComDamageType;
var Vector m_vHitLocation;
var Vector m_vMomentum;
var Weapon m_kDroppedWeapon;
var XComPawn m_kCachedPawn;
var XGUnit m_kCurrTarget;
var transient AnimNodeSequence tmpAnimSequence;
var bool m_bWasStrangling;
var bool m_kDyingMindMergeSource;
var bool m_bInitialReplicationDataReceived_XGAction_Death;
var bool m_bGlamCamActive;
var bool m_bDeathCinematic;
var bool bInFinalRagdollState;
var bool bPlayingDeathAnimation;
var bool bKilledByKineticStrike;
var bool bPerformingKineticStrikeDeath;
var bool bPlayingCinematicKinematicStrikeDeath;
var transient float fTimeOut;
var transient XGUnit m_kLastMindMergedUnit;
var repnotify InitialReplicationData_XGAction_Death m_kInitialReplicationData_XGAction_Death;
var transient Vector m_vDeathCinematicVector;
var EMoveType m_RestoreMoveState;
var EAnimAction m_RestoreActionState;
var EAnimAction m_eAnimToPlay;
var EDeathActionStatus m_eDeathStatus;
var int NumStartingCustomFireNotifies;
var float TimeToRagdoll;
var float StartedDeathTime;
var Vector LastHeadBoneLocation;
var export editinline array<export editinline PrimitiveComponent> TempCollisionComponents;
var MaterialInstanceTimeVarying m_kMITV_Robe;
var name m_nmExaltSuicide;
var private float HACK_fGhettoDeathStuckLoopingTimeoutSeconds;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Death;
}

simulated event ReplicatedEvent(name VarName){}

simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit, XGUnit kDamageDealer, int iDamage, class<DamageType> kDamageType, Vector vHitLocation, Vector vMomentum, Actor kDamageCauser, Weapon kDroppedWeapon, XComPawn kCachedPawn){}
function bool CanBePerformed(){}
simulated function string InitialReplicationData_XGAction_Death_ToString(InitialReplicationData_XGAction_Death kInitRepData){}
event OnAllClientsComplete(){}
simulated function bool HasMultipleTargets(out array<XGUnit> arrTarget_out){}
simulated function bool Projectile_OverrideStartPositionAndDir(out Vector tempTrace, out Vector tempDir){}
simulated function bool IsUnitMindMerged(){}
simulated function GetProjectileDamage(bool bCanDoDamage, XComProjectile kProjectile, XComWeapon kWeapon, out XComUnitPawn kTargetPawn, out XGUnitNativeBase kTargetUnit, out int iDamageAmount, out int iWorldDamage){}
simulated function bool IsHit(){}
simulated function bool IsCritical(){}
simulated function bool IsKillShot(){}
simulated function bool IsReflected(){}
simulated function EAnimAction ComputeAnimationToPlay(optional int iShieldDamage){}
simulated function string GetDebugHangLog(){}
simulated function InternalCompleteAction(){}

simulated state Executing
{
    simulated event Tick(float fDeltaTime){}
    simulated function TickKineticStrikeDeath(){}
    simulated function CleanupKineticStrikeDeath(){}
    simulated function SetupKineticStrikeMatineeLocations(){}
}

