class XComUnitPawn extends XComLocomotionUnitPawn
    abstract
    dependson(XGCharacter_Soldier)
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

const MAX_TARGETS = 16;

enum EXComUnitPawn_RagdollFlag
{
    ERagdoll_IfDamageTypeSaysTo,
    ERagdoll_Always,
    ERagdoll_Never,
    ERagdoll_MAX
};

struct PhysicsState
{
    var bool m_bNeedsRestoring;
    var EPhysics m_ePhysics;
    var bool m_bCollideWorld;
    var bool m_bCollideActors;
    var bool m_bBlockActors;
    var bool m_bIgnoreEncroachers;
};

var() Vector LocalCameraOffset;
var() float CameraFocusDistance;
var() Vector2D AimLimit;
var() float AimSpeedFactor;
var() float AimStopThreshold;
var() float AimSpeedMin;
var() float AimSpeedMax;
var() float AimAtTargetMissPercent;
var() float TurnSpeedMultiplier;
var protected array<int> m_kUpdateWhenNotRenderedStack;
var XComTacticalGame m_kTacticalGame;
var repnotify CharacterParameters m_kReplicatedCharacterParams;
var XComAnimNodeJetpack m_kJetPackNode;
var() XComFootstepSoundCollection Footsteps;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var export editinline StaticMeshComponent RangeIndicator;
var StaticMesh CloseAndPersonalRing;
var StaticMesh ArcThrowerRing;
var StaticMesh CivilianRescueRing;
var StaticMesh MedikitRing;
var StaticMesh KineticStrikeCard;
var StaticMesh FlamethrowerCard;
var() DamageTypeHitEffectContainer DamageEffectContainer;
var bool m_bInMatinee;
var bool m_bRemainInAnimControlForDeath;
var() bool PlayNonFootstepSounds;
var() bool bDoDyingActions;
var() bool SmashEnvironmentOnDeath;
var privatewrite bool m_bPawnPerkContentInitialized;
var() bool m_bHasFullAnimWeightBones;
var bool bIsFemale;
var bool bUseBoneSprings;
var bool m_bInWater;
var() bool m_bOnlyAllowAnimLeftHandIKNotify;
var() bool m_bDropWeaponOnDeath;
var private transient bool m_bAnimOverrideZeroAimOffset;
var bool m_bTutorialCanDieInMatinee;
var bool bAllowPersistentFX;
var private bool m_bWasIdleBeforeMatinee;
var Actor m_kLookAtTarget;
var() float PhysicsPushScale;
var() EXComUnitPawn_RagdollFlag RagdollFlag;
var() float RagdollBlendTime;
var export editinline array<export editinline PrimitiveComponent> TempCollisionComponents;
var float RagdollFinishTimer;
var float WaitingToBeDestroyedTimer;
var Vector DyingImpulse;
var TraceHitInfo DyingHitInfo;
var PhysicsState m_kLastPhysicsState;
var() XComDeathHandler DeathHandlerTemplate;
var XComDeathHandler m_deathHandler;
var repnotify Vector m_vTeleportToLocation;
var export editinline ParticleSystemComponent arrMindMergeSend[16];
var export editinline ParticleSystemComponent MindMergeFX_Send;
var export editinline ParticleSystemComponent MindMergeFX_Receive;
var export editinline ParticleSystemComponent PsiPanicFX_Receive;
var export editinline ParticleSystemComponent MindFrayFX_Receive;
var export editinline ParticleSystemComponent MindControlFX_Send;
var export editinline ParticleSystemComponent MindControlFX_Receive;
var export editinline ParticleSystemComponent PsiInspiredFX_Receive;
var export editinline ParticleSystemComponent DisablingShot_Receive;
var ParticleSystem StunShot_ReceiveTemplate;
var export editinline ParticleSystemComponent StunShot_Receive;
var export editinline ParticleSystemComponent TracerBeamedFX;
var ParticleSystem TracerBeamedFXTemplate;
var export editinline ParticleSystemComponent PoisonedByChryssalidFX;
var ParticleSystem PoisonedByChryssalidFXTemplate;
var export editinline ParticleSystemComponent PoisonedByThinmanFX;
var ParticleSystem PoisonedByThinmanFXTemplate;
var export editinline ParticleSystemComponent ElectropulsedFX;
var ParticleSystem ElectropulsedFXTemplate;
var transient XComGrappleLine GrappleLine;
var() array<Texture2D> UITextures;
var float fPhysicsMotorForce;
var Vector LastHeadBoneLocation;
var float m_fWaterWorldZ;
var array<ParticleSystem> m_aInWaterParticleSystems;
var TriggerVolume m_kLastWaterVolume;
var() const SkeletalMesh CovertOpsMesh;
var() const SkeletalMesh ExaltSuicideSyringeMesh;
var() float CloseRangeMissDistance;
var() float NormalMissDistance;
var() float NormalMissAngleMultiplier;
var() float CloseRangeMissAngleMultiplier;
var protected float fHiddenTime;

defaultproperties
{
    LocalCameraOffset=(X=-50.0,Y=38.0,Z=0.0)
    CameraFocusDistance=6400.0
    AimLimit=(X=12000.0,Y=6000.0)
    AimSpeedFactor=0.000250
    AimStopThreshold=500.0
    AimSpeedMin=0.050
    AimSpeedMax=2.0
    AimAtTargetMissPercent=1.0
    TurnSpeedMultiplier=1.0
    m_kReplicatedCharacterParams=(iShape=0,iFacialHairMask=0,cEyeColor=(R=0.0,G=0.0,B=0.0,A=1.0),cHairColor=(R=0.0,G=0.0,B=0.0,A=1.0),cSkinColor=(R=0.0,G=0.0,B=0.0,A=1.0),fEyebrowOffsetX=0.0,fEyebrowOffsetY=0.0,fEyebrowInvScale=0.0,fEyebrowRotation=0.0,bGlasses=false,bHeadband=false,iArmsClothedM=0,iArmsBareM=0,iGlovesM=0,iShoulderPadsM=0,iKneePadsM=0,iBootsM=0,iPouches=0,iChestPatch=0,iAccessories=0,iTattoos=0,Decals=(kAngles=(X=0.0,Y=0.0,Z=0.0),fWidth=0.0,fHeight=0.0,fAlpha=0.0),Decals[1]=(kAngles=(X=0.0,Y=0.0,Z=0.0),fWidth=0.0,fHeight=0.0,fAlpha=0.0))
    CloseAndPersonalRing=StaticMesh'UI_Range.Meshes.RadiusRing_CloseAndPersonal'
    ArcThrowerRing=StaticMesh'UI_Range.Meshes.RadiusRing_ArcThrower'
    CivilianRescueRing=StaticMesh'UI_Range.Meshes.RadiusRing_CivRescue'
    MedikitRing=StaticMesh'UI_Range.Meshes.RadiusRing_MedKit'
    KineticStrikeCard=StaticMesh'UI_Range.Meshes.KinetiStrikeDir_Plane'
    FlamethrowerCard=StaticMesh'UI_Range.Meshes.96Triangle'
    PlayNonFootstepSounds=true
    bDoDyingActions=true
    bAllowPersistentFX=true
    PhysicsPushScale=1.0
    RagdollBlendTime=0.50
    RagdollFinishTimer=10.0
    WaitingToBeDestroyedTimer=3600.0
    fPhysicsMotorForce=100.0
    CloseRangeMissDistance=512.0
    NormalMissDistance=1024.0
    NormalMissAngleMultiplier=3.0
    CloseRangeMissAngleMultiplier=1.0
    m_bUseRMA=true
    m_bAuxParamNeedsPrimary=true
    HeadBoneName=RigHead
    m_kAuxiliaryMaterial_ZeroAlpha=Material'FX_Visibility.Materials.MPar_NoUnitGlow'
    m_DefaultLightingChannels=(bInitialized=true,Dynamic=true)
    m_fPercent=100.0
    MaxStepHeight=48.0
    WalkableFloorZ=0.10
    bPushesRigidBodies=true
    MeleeRange=128.0
    GroundSpeed=1.0
    BaseEyeHeight=40.0
    ControllerClass=none
    RBPushRadius=8.0
    RBPushStrength=5.0
    CollisionType=COLLIDE_BlockAll
    bBlockActors=false
    RotationRate=(Pitch=20000,Yaw=40000,Roll=20000)

    begin object name=MyLightEnvironment class=DynamicLightEnvironmentComponent
        InvisibleUpdateTime=4.0
        MinTimeBetweenFullUpdates=0.0
        bCastShadows=false
        bForceCompositeAllLights=true
        bUseBooleanEnvironmentShadowing=false
        bSynthesizeSHLight=true
        bIsCharacterLightEnvironment=true
        MaxModulatedShadowColor=(R=0.40,G=0.40,B=0.40,A=1.0)
        bDoNotResetOnAttachingTo=true
        bUseBiasedSubjectMatrix=true
        fBiasedSubjectFarDistance=150.0
    end object

    LightEnvironment=MyLightEnvironment

    begin object name=RangeIndicatorMeshComponent class=StaticMeshComponent
        HiddenGame=true
        bAcceptsStaticDecals=false
        bAcceptsDynamicDecals=false
        CastShadow=false
        bAcceptsLights=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object

    RangeIndicator=RangeIndicatorMeshComponent

    begin object name=MindMergeFX_Send0 class=ParticleSystemComponent
        bAutoActivate=false
        bIgnoreOwnerHidden=true
    end object

    MindMergeFX_Send=MindMergeFX_Send0

    begin object name=MindMergeFX_Receive0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    MindMergeFX_Receive=MindMergeFX_Receive0

    begin object name=PsiPanicFX_Receive0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    PsiPanicFX_Receive=PsiPanicFX_Receive0

    begin object name=MindFrayFX_Receive0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    MindFrayFX_Receive=MindFrayFX_Receive0

    begin object name=MindControlFX_Send0 class=ParticleSystemComponent
        bAutoActivate=false
        bIgnoreOwnerHidden=true
    end object

    MindControlFX_Send=MindControlFX_Send0

    begin object name=MindControlFX_Receive0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    MindControlFX_Receive=MindControlFX_Receive0

    begin object name=PsiInspiredFX_Receive0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    PsiInspiredFX_Receive=PsiInspiredFX_Receive0

    begin object name=DisablingShot_Receive0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    DisablingShot_Receive=DisablingShot_Receive0

    begin object name=StunShot_Receive0 class=ParticleSystemComponent
        bAutoActivate=false
    end object

    StunShot_Receive=StunShot_Receive0

    begin object name=TracerBeamed class=ParticleSystemComponent
        bAutoActivate=false
    end object

    TracerBeamedFX=TracerBeamed

    begin object name=PoisonedByChryssalid class=ParticleSystemComponent
        bAutoActivate=false
    end object

    PoisonedByChryssalidFX=PoisonedByChryssalid

    begin object name=PoisonedByThinman class=ParticleSystemComponent
        bAutoActivate=false
    end object

    PoisonedByThinmanFX=PoisonedByThinman

    begin object name=Electropulsed class=ParticleSystemComponent
        bAutoActivate=false
    end object

    ElectropulsedFX=Electropulsed

    begin object name=SkeletalMeshComponent class=SkeletalMeshComponent
        bUpdateSkelWhenNotRendered=false
        bUpdateKinematicBonesFromAnimation=false
        bUpdateJointsFromAnimation=true
        LightEnvironment=MyLightEnvironment
        bNeedsGameThreadVisibility=true
        bAcceptsDynamicDecals=true
        CollideActors=true
        BlockZeroExtent=true
        bNotifyRigidBodyCollision=true
        LightingChannels=(bInitialized=true,Dynamic=true,Gameplay_1=true)
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
        ScriptRigidBodyCollisionThreshold=300.0
    end object

    Mesh=SkeletalMeshComponent

    begin object name=UnitCollisionCylinder class=CylinderComponent
        CollisionRadius=14.0
        RBChannel=ERBCollisionChannel.RBCC_Pawn
        HiddenGame=false
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=false
        CanBlockCamera=true
        BlockRigidBody=true
        RBCollideWithChannels=(Default=true,Vehicle=true,Water=true,GameplayPhysics=true,EffectPhysics=true,Untitled1=true,Untitled2=true,Untitled3=true,Untitled4=true,Cloth=true,FluidDrain=true,SoftBody=true,BlockingVolume=true,DeadPawn=true)
    end object

    CylinderComponent=UnitCollisionCylinder
    CollisionComponent=UnitCollisionCylinder

    Components(0)=none
    Components(1)=none
    Components(2)=MyLightEnvironment
    Components(3)=SkeletalMeshComponent
    Components(4)=UnitCollisionCylinder
    Components(5)=RangeIndicatorMeshComponent
    Components(6)=MindMergeFX_Send0
    Components(7)=MindMergeFX_Receive0
    Components(8)=PsiPanicFX_Receive0
    Components(9)=MindFrayFX_Receive0
    Components(10)=MindControlFX_Send0
    Components(11)=MindControlFX_Receive0
    Components(12)=PsiInspiredFX_Receive0
    Components(13)=DisablingShot_Receive0
    Components(14)=StunShot_Receive0

    // SupportedEvents=/* Array type was not detected. */
}