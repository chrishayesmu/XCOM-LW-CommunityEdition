class XComProjectile extends Projectile
    abstract
    native(Weapon)
    nativereplication
    hidecategories(Navigation);
//complete stub

enum EProjectileTelekineticFieldState
{
    EPTKFS_None,
    EPTKFS_Diverting,
    EPTKFS_MAX
};

struct ProjectileExplosionInfo
{
    var float m_fDamage;
    var float m_fDamageRadius;
    var float m_fMomentumTransfer;
    var Vector m_vHitLocation;
    var Vector m_vHitNormal;
    var Vector m_vLocation;
    var Rotator m_rRotation;
    var Actor m_kImpactedActor;
    var bool m_bImpactedActorNone;
    var bool m_bHasExploded;
    var bool bWillDoDamage;
    var XComUnitPawnNativeBase TargetPawn;
    var XGUnitNativeBase TargetUnit;
    var bool bIsHit;
    var int UnitDamage;
    var int WorldDamage;
    var bool m_bHumanTargetedShotNone;
    var XGAbility_Targeted m_kHumanTargetedShot;
    var Vector m_vHumanTargetedLocation;
    var bool HACK_bForceExplodeBullRushProjectile;
};

struct FakeTouchEvent
{
    var float Time;
    var Actor TouchActor;
    var Vector HitLocation;
    var Vector HitNormal;
};

var bool m_bShowDamage;
var bool m_bWasCrit;
var bool bWillDoDamage;
var bool bIsHit;
var() bool bWaitForEffects;
var(XComProjectileImpact) bool bDontAlignDeathFXToSurface;
var bool bPreview;
var const bool bHasExploded;
var bool m_bProximityMine;
var bool m_bShuttingDown;
var bool m_bClientExploded;
var bool m_bServerExploded;
var repnotify bool HACK_bForceExplodeClientProjectile;
var bool m_bHiddenBecauseInstigatorIsHidden;
var transient bool bTargetLocSeeking;
var transient bool bTargetSeekCorrected;
var bool HACK_bMindMergeDeathProjectile;
var repnotify const bool HACK_bMindMergeDeathProjectileHasExploded;
var bool HACK_bNeuralFeedbackProjectile;
var repnotify const bool HACK_bNeuralFeedbackProjectileHasExploded;
var bool HACK_bServerCreatedFromPsiRoll;
var bool HACK_bServerCreatedFromPsiLance;
var bool bIsPooledProjectile;
var bool bIsCurrentlyBeingUsed;
var repnotify ProjectileExplosionInfo m_kExplosionInfo;
var XComUnitPawn TargetPawn;
var XGUnitNativeBase TargetUnit;
var float m_fDistanceToTargetSq;
var int UnitDamage;
var array<XComProjectileEventListener> m_arrProjectileEventListeners;
var XGAbility_Targeted m_kHumanTargetedShot;
var Vector m_vHumanTargetedLocation;
var array<FakeTouchEvent> FakeTouchEvents;
var() export editinline SkeletalMeshComponent Mesh;
var() export editinline ParticleSystemComponent ProjectileTrailEffect;
var() name ProjectileTrailSocket;
var() export editinline PointLightComponent ProjectileLightComponent;
var() float fDelayBeforeMovement;
var() float fMaxRange;
var() float fConstantTimeToTarget;
var() export editinline XComExplosionLight MuzzleFlashLight;
var transient int WorldDamage;
var(XComProjectileImpact) export editinline ParticleSystemComponent DeathFX;
var(XComProjectileImpact) export editinline ParticleSystemComponent OngoingTargetFX;
var(XComProjectileImpact) export editinline ParticleSystemComponent OngoingTransmitFX;
var(XComProjectileImpact) SoundCue DeathSoundCue;
var(XComProjectileImpact) XComProjectileImpactActor ImpactDataTemplate;
var(XComProjectileImpact) export editinline XComExplosionLight ExplosionLight;
var(XComProjectileImpact) ParticleSystem FailedTargetFX;
var export editinline ParticleSystemComponent TelekineticFieldProjectileTrail;
var export editinline ParticleSystemComponent TelekineticFieldProjectileTrailFailure;
var transient Vector OriginalVelocity;
var transient Vector OriginalLocation;
var float fLightTimeRemaining;
var Actor TracedImpactActor;
var TraceHitInfo TracedImpactInfo;
var Vector TracedImpactLocation;
var Vector TracedImpactNormal;
var int m_iTurnToExplode;
var XGUnitNativeBase m_kFiredFromUnit;
var() float m_fLifeTime;
var XComProjectile m_kServerProjectile;
var XComProjectile m_kClientProjectile;
var repnotify XComFiredProjectileList m_kFiredProjectileList;
var repnotify TXComFiredProjectileListNode m_kFiredProjectileListNode;
var transient Vector TargetLocation;
var transient EItemType WeaponType;
var transient EProjectileTelekineticFieldState m_eCurrentTelekineticFieldState;
var transient float fMinDistanceRequiredBeforeExplode;
var transient float m_fOutsideWorldGridTime;
var transient Vector m_vPerformTelekineticField_DesiredDir;
var transient float m_vPerformTelekineticField_DesiredSpeed;
var() float fTelekineticFieldSpeedPct;
var() float fTelekineticFieldSpeedRate;
var() float fTelekineticFieldDivertAngle;
var() float fTelekineticFieldDivertRate;
var export editinline ParticleSystemComponent TracerBeamTrailEffect;
var export editinline ParticleSystemComponent HeatBulletTrailEffect;
var export editinline ParticleSystemComponent HeatRocketTrailEffect;
var export editinline ParticleSystemComponent ShredderRocketTrailEffect;
var export editinline ParticleSystemComponent ReaperRoundsTrailEffect;
var XComProjectile ProjectileTemplate;
var const float m_fTimeUnusedTillRecycle;
var const float m_fMPLifeSpan;


native simulated function InitProjectileFromPool(XComWeapon OwnerWeapon, Vector NewPosition);
simulated function AddProjectileEventListenter(XComProjectileEventListener kListener){}
simulated function RemoveProjectileEventListener(XComProjectileEventListener kListener){}
simulated function NotifyListeners_OnInit(){}
simulated function NotifyListeners_OnShutdown(){}
simulated function NotifyListeners_OnDealDamage(){}
native simulated function SetHasExploded(bool _bHasExploded);
simulated function bool IsProjectileBeyondMaxRange(){}
simulated function MakeThisADamageProjectile(int iWorldDmg, optional int iRadius=1, optional int iDamage){}
simulated function bool IsOutsideWorldGrid(){}
simulated function bool HasProjectileExceededOutsideWorldGridTravelDistance(float fDeltaTime){}
native simulated function Vector CalculateDivertedTelekineticFieldDirection();
native simulated function Vector UpdateDivertedTelekineticFieldDirection(float DeltaTime);
native simulated function Vector CalculateTelekineticFieldIntersectLocation(CylinderComponent kField);
simulated function ProcessTelekineticField(float DeltaTime){}
simulated event Tick(float DeltaTime){}
simulated event PostBeginPlay(){}
function InitFX(bool bResetParticles, bool bHit){}
native simulated function FakeTouches(Vector Start, Vector End){};
simulated event ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal){}
singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp){}
simulated function HideProjectile(){}
native simulated function ShowProjectile();
simulated function OverrideSpeed(){}
simulated function InitProjectile(Vector Direction, optional bool bPreviewOnly, optional bool bCanDoDamage=true){}
function ProcessFakeTouchEvents(){}
function CalculateUnitDamage(){}
simulated function XGWeapon GetGameWeapon(){}
simulated function InitPreview();
simulated function ProjDamage_ProcessIgnoredActors(out DamageEvent kDamageEvent){}
simulated function bool DealSplashDamage(Vector HurtOrigin){}
simulated function TraceAtHitPosition(Vector HitLocation, Vector HitNormal){}
simulated function Explode(Vector HitLocation, Vector HitNormal){}
simulated function KillEffects(){}
simulated function DestroyProjectile(){}
simulated function ShutdownProjectile(Vector HitLocation, Vector HitNormal){}
simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal){}
simulated function DisableEffects(){}
simulated function CleanupTrailEffect(ParticleSystemComponent TrailEffect){}
simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, Vector vCameraPosition, Vector vCameraDir){}
simulated function string ProjectileExplosionInfo_ToString(ProjectileExplosionInfo kExplosionInfo){}
simulated function LinkToServerProjectile(){}
simulated function LinkToClientProjectile(){}
simulated function DoReplicatedExplode(){}
simulated event ReplicatedEvent(name VarName){}
simulated function HACKForceExplodeClientProjectile(){}
simulated function OnReplicationLinkProjectilesAndCheckForExplode(){}
simulated function int GetUnitDamage(){}
simulated function DestroyForPool(){}
simulated event Destroyed(){}
native function SetupFakeTouchEvents(const out Vector ProjectileLocation, const out Vector ProjectileVelocity);
