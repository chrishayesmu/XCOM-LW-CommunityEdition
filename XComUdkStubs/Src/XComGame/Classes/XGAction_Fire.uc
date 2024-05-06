class XGAction_Fire extends XGAction
    native(Action)
    notplaceable
    hidecategories(Navigation)
    implements(DamageDealingAction);

const ACTION_FIRE_MAX_PROJECTILES = 32;
const CINEMATIC_DELAY_TIME = 0.5f;
const HANG_WARN_TIME = 8;
const HANG_BREAKOUT_TIME = 20;
const FACING_TARGET_MINDOT = 0.98f;

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
var protected bool m_bWeaponWasFired;
var protected bool m_bShotIsBlocked;
var private bool m_bForceOverheadCamera;
var privatewrite bool m_bHumanTargeted;
var private bool m_bExitedCover;
var bool m_bFireActionDoEarlyCC;
var bool m_bStartEarlyFireActionCC;
var bool m_bExecutedAbility;
var bool bForceHit;
var bool bForceMiss;
var bool bDidGlamCamCheck;
var private bool m_bFiringStateRepDataReceived_WaitOnExecutingShotAbility;
var bool m_bGlamCamActive;
var bool m_bCameraIsFinished;
var bool m_bCameraIsReady;
var bool m_bDebugEmergencyAbort;
var protectedwrite bool m_bStartedStateFiring;
var protectedwrite bool m_bBottomOfExecutingState;
var bool m_bUpdateAnimRot;
var bool m_bUseAimAtTargetMissPercentage;
var bool m_bIsInterruptible;
var bool m_bDemoEndingDone;
var protected bool m_bUnitIsActive;
var transient bool m_bWaitingForOverwatchToComplete;
var transient bool m_bGrappleShouldClimbOverLedge;
var transient bool m_bGrappleIsValid;
var transient bool m_bGrappled;
var private bool m_bGrappleStateDataReplicated;
var bool m_bAttackerVisibleToEnemy;
var bool m_bProjectileWillBeVisibleToEnemy;
var private bool m_bInitialReplicationDataReceived_XGAction_Fire;
var private bool m_bReplicateShot;
var protected bool m_bDisableShotReplicationWhenFiring;
var bool m_bClientShotFinishedExecution;
var bool m_bNotifyExecutedShot;
var privatewrite bool m_bHasAdrenalNeurosympathy;
var privatewrite bool m_bAdrenalNeurosympathyOnCooldown;
var bool m_bFiringPanDone;
var bool bClusterBombSetup;
var bool bClusterBombFiring;
var private bool m_bTriggeredReflection;
var bool bMutonBeatDownGlamCam;
var bool bMutonBeatUpGlamCam;
var bool bChryssalidBiteGlamCam;
var bool bSpokeAboutMiss;
var privatewrite bool m_bClientStopWaitingForFiringStateShotAbility;
var Actor TargetActor;
var protected Vector m_vTarget;
var float fPreviewTimer;
var XGWeapon m_kWeapon;
var array<XGUnit> m_arrVictims;
var XGUnit m_kTargetedEnemy;
var XGAbility_Targeted m_kShot;
var privatewrite Vector m_vHumanTargetedLocation;
var int CurrentShotIndex;
var FiringStateReplicationData CurrentShotReplicationData;
var int m_iTracerBeamShots;
var float m_fExtraSleepTimePostShutdown;
var private repnotify FiringStateReplicationData_WaitOnExecutingShotAbility m_kFiringStateRepData_WaitOnExecutingShotAbility;
var XGCameraView m_kSavedView;
var XGCameraView m_kAimingView;
var XGCameraView_Firing m_kFiringView;
var XGCameraView_Midpoint m_kMidpointView;
var protected XComProjectile m_arrProjectiles[32];
var protected int m_numProjectiles;
var ECoverState m_eStoredCoverState;
var transient EAnimAction m_TmpAnimActionIndex;
var transient ESingleAnim m_TmpSingleAnim;
var XGAction_Fire.EFireActionStatus m_eFireActionStatus;
var XGAction_Fire.ECustomFireActionType CustomFireActionType;
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
var private repnotify GrappleStateReplicationData m_kGrappleStateRepData;
var protected int m_iNumProjectileOnDealDamageCalls;
var protected int m_iNumProjectileMissCalls;
var transient Vector vSelectedTargetLocation;
var protected XComFiredProjectileList m_kFiredProjectileList;
var private repnotify repretry InitialReplicationData_XGAction_Fire m_kInitialReplicationData_XGAction_Fire;
var int m_iNumTimesFired;
var Actor CustomFireActor;
var protected Vector m_vHitLocation;

defaultproperties
{
    m_bAttackerVisibleToEnemy=true
    m_bProjectileWillBeVisibleToEnemy=true
    m_bReplicateShot=true
    m_bDisableShotReplicationWhenFiring=true
    CurrentShotReplicationData=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0))
    m_kInitialReplicationData_XGAction_Fire=(m_kFiredProjectileList=none,m_bFiredProjectileListNone=false,m_bForceOverheadCamera=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_vTarget=(X=0.0,Y=0.0,Z=0.0),m_kTargetActor=none,m_bTargetActorNone=false,m_kShot=none,m_bShotNone=false,m_bShotIsBlocked=false,m_bClusterBombSetup=false,m_bClusterBombFiring=false,m_bHasAdrenalNeurosympathy=false,m_bAdrenalNeurosympathyOnCooldown=false,m_bGrappleIsValid=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0),NumShots=0,m_arrFiringStateRepDatas=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[1]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[2]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[3]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[4]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[5]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[6]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[7]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[8]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[9]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[10]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[11]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[12]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[13]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[14]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_arrFiringStateRepDatas[15]=(m_bHit=false,m_bCritical=false,m_iDamage=-1,m_bKillShot=false,m_bAttackerVisibleToEnemy=true,m_bProjectileWillBeVisibleToEnemy=true,m_bPlaySuccessfulKillAnimation=false,m_kTargetActor=none,m_bTargetActorNone=false,m_kTargetedEnemy=none,m_bTargetedEnemyNone=false,m_bReflected=false,m_bReplicated=false,m_bCanApplyTracerBeamFX=false,m_bShotIsBlocked=false,m_vHitLocation=(X=0.0,Y=0.0,Z=0.0)),m_bHumanTargeted=false,m_vHumanTargetedLocation=(X=0.0,Y=0.0,Z=0.0),m_kStrangleTarget=none,m_bStrangleTargetNone=false)
    m_bBlocksInput=true
    m_bConstantCombat=true
    m_bShouldUpdateOvermind=true
}