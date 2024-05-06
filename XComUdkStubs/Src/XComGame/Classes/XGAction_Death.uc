class XGAction_Death extends XGAction
    notplaceable
    hidecategories(Navigation)
    implements(DamageDealingAction);

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
var private bool m_bInitialReplicationDataReceived_XGAction_Death;
var bool m_bGlamCamActive;
var bool m_bDeathCinematic;
var bool bInFinalRagdollState;
var bool bPlayingDeathAnimation;
var bool bKilledByKineticStrike;
var bool bPerformingKineticStrikeDeath;
var bool bPlayingCinematicKinematicStrikeDeath;
var transient float fTimeOut;
var transient XGUnit m_kLastMindMergedUnit;
var private repnotify repretry InitialReplicationData_XGAction_Death m_kInitialReplicationData_XGAction_Death;
var transient Vector m_vDeathCinematicVector;
var XComAnimNodeBlendByMovementType.EMoveType m_RestoreMoveState;
var XComAnimNodeBlendByAction.EAnimAction m_RestoreActionState;
var XComAnimNodeBlendByAction.EAnimAction m_eAnimToPlay;
var XGAction_Death.EDeathActionStatus m_eDeathStatus;
var int NumStartingCustomFireNotifies;
var float TimeToRagdoll;
var float StartedDeathTime;
var Vector LastHeadBoneLocation;
var export editinline array<export editinline PrimitiveComponent> TempCollisionComponents;
var MaterialInstanceTimeVarying m_kMITV_Robe;
var name m_nmExaltSuicide;
var private float HACK_fGhettoDeathStuckLoopingTimeoutSeconds;

defaultproperties
{
    m_bShouldUpdateOvermind=true
}