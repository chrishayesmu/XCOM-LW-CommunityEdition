class XComProjectile extends Projectile
    abstract
    native(Weapon)
    nativereplication
    hidecategories(Navigation);

const MIN_ARMING_DISTANCE = 192.0f;

enum EProjectileTelekineticFieldState
{
    EPTKFS_None,
    EPTKFS_Diverting,
    EPTKFS_MAX
};

struct native ProjectileExplosionInfo
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

struct native FakeTouchEvent
{
    var float Time;
    var Actor TouchActor;
    var Vector HitLocation;
    var Vector HitNormal;
};

var bool m_bShowDamage;
var bool m_bWasCrit;
var protectedwrite bool bWillDoDamage;
var protectedwrite bool bIsHit;
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
var repnotify repretry ProjectileExplosionInfo m_kExplosionInfo;
var protectedwrite XComUnitPawn TargetPawn;
var protectedwrite XGUnitNativeBase TargetUnit;
var protectedwrite float m_fDistanceToTargetSq;
var protectedwrite int UnitDamage;
var protectedwrite array<XComProjectileEventListener> m_arrProjectileEventListeners;
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

defaultproperties
{
    bWaitForEffects=true
    fMaxRange=20000.0
    m_iTurnToExplode=-1
    m_fLifeTime=15.0
    m_kFiredProjectileListNode=(m_kNextFiredProjectile=none,m_bNextFiredProjectileNone=false,m_kPrevFiredProjectile=none,m_bPrevFiredProjectileNone=false,m_iIndexInList=-1)
    fTelekineticFieldSpeedPct=0.10
    fTelekineticFieldSpeedRate=50000.0
    fTelekineticFieldDivertAngle=30.0
    fTelekineticFieldDivertRate=90.0
    m_fTimeUnusedTillRecycle=15.0
    m_fMPLifeSpan=15.0
    Speed=3000.0
    MaxSpeed=3000.0
    bBlockedByInstigator=false
    MomentumTransfer=4000.0
    bNetTemporary=false
    bAlwaysRelevant=true
    LifeSpan=0.0

    begin object name=CollisionCylinder
        CollisionHeight=1.0
        CollisionRadius=1.0
    end object

    begin object name=PointLightComponent0 class=PointLightComponent
        CastShadows=false
        CastStaticShadows=false
        CastDynamicShadows=false
        LightingChannels=(BSP=false,Static=false)
    end object

    ProjectileLightComponent=PointLightComponent0

    begin object name=DeathFX class=ParticleSystemComponent
        bAutoActivate=false
    end object

    DeathFX=DeathFX

    begin object name=TelekineticFieldProjectileTrail0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    TelekineticFieldProjectileTrail=TelekineticFieldProjectileTrail0

    begin object name=TelekineticFieldProjectileTrailFailure0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    TelekineticFieldProjectileTrailFailure=TelekineticFieldProjectileTrailFailure0

    begin object name=TracerBeamTrailEffect0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    TracerBeamTrailEffect=TracerBeamTrailEffect0

    begin object name=HeatBulletTrailEffect0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    HeatBulletTrailEffect=HeatBulletTrailEffect0

    begin object name=HeatRocketTrailEffect0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    HeatRocketTrailEffect=HeatRocketTrailEffect0

    begin object name=ShredderRocketTrailEffect0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    ShredderRocketTrailEffect=ShredderRocketTrailEffect0

    begin object name=ReaperRoundsTrailEffect0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    ReaperRoundsTrailEffect=ReaperRoundsTrailEffect0
}