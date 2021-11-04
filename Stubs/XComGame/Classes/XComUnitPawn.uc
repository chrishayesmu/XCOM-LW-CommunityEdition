class XComUnitPawn extends XComLocomotionUnitPawn
	DependsOn(XGCharacter_Soldier);
//complete stub
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
var bool m_bPawnPerkContentInitialized;
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
var float fHiddenTime;


event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex){}
simulated event SetInWater(bool bInWater, optional float fWaterWorldZ, optional array<ParticleSystem> InWaterParticles){}
simulated event SetVisible(bool bVisible){}
simulated event Attach(Actor Other){}
simulated event Detach(Actor Other){}
simulated function EnableRMAInteractPhysics(bool bEnable){}
function SetCinLightingChannels(){}
function RestoreDefaultLightingChannels(){}
function SetXGCharacter(XGCharacter kXGCharacter){}
simulated function PlayerController GetOwningPlayerController(){}
function bool IsSeenByCamera(){}
simulated function ResetAimOffset(){}
simulated function ComputeAimOffsetToLocation(Vector vLoc, optional EExitCoverTypeToUse eExitCoverType=eECTTU_Zero){}
simulated function bool IsAimedAtTargetLoc(optional float fAccuracy=500.0){}
simulated function LookAt(Actor kLookAt){}
simulated event PlayFootStepSound(int FootDown){}
simulated event PlayInWaterParticles(int FootDown){}
reliable client simulated function UnitSpeak(ECharacterSpeech eCharSpeech);
simulated function bool HasHeadBone(){}
simulated function Vector GetHeadLocation(){}
event Landed(Vector HitNormal, Actor FloorActor){}
event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal){}
function ApplyImpulseToPhysicsActor(Actor PhysActor, Vector Impulse, Vector HitLocation){}
simulated function ApplyShredderRocket(const DamageEvent Dmg, bool enemyOfUnitHit){}
simulated function bool CanApplyTracerBeams(XGAbility_Targeted kAbility, XGUnit kAttacker, XGUnit kVictim){}
simulated function ApplyTracerBeams(XGUnit kAttacker, XGUnit kVictim, XGAbility_Targeted kAbility){}
simulated function ApplyDisablingShot(){}
simulated function ApplyStunFX(){}
simulated event TakeDirectDamage(const DamageEvent Dmg){}
simulated event TakeSplashDamage(DamageEvent Dmg){}
simulated function PlayHitEffects(float Damage, Actor InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum){}
simulated function SkelMeshOptimizationCheck(optional bool bEnable=FALSE){}
simulated function bool ShouldRagDoll(class<XComDamageType> DamageTypeClass){}
simulated function XComSuperPlayDying(class<DamageType> DamageTypeClass, Vector HitLoc){}
simulated function PlayDying(class<DamageType> DamageTypeClass, Vector HitLoc){}
simulated function StartRagDoll(optional bool bDoBoneSprings=TRUE){}
simulated function EndRagDoll(){}
simulated event Tick(float dt){}
simulated function SkeletalMeshComponent GetPrimaryWeaponMeshComponent(){}
simulated function name GetLeftHandIKSocketName(){}
simulated event Vector GetLeftHandIKTargetLoc(){}
simulated function bool IsSwitchingSides(){}
simulated function EnableLeftHandIK(bool bEnable){}
function OnFinishRagdoll();
simulated function FinishRagDollExternal();
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){}
simulated event PostBeginPlay(){}
simulated function InitializeParticleFXTemplates(){}
simulated function XComUpdateCylinderSize(bool bAlert){}
simulated function ResetIKTranslations(){}
simulated event Destroyed(){}
event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal){}
event UnTouch(Actor Other){}
simulated function int GetCurrentFloor(){}
simulated function OnChangedIndoorStatus(){}
simulated function ChangeLightEnvironmentForCurrentEnvironment(LightEnvironmentComponent LightEnvironmentC){}
simulated event OnUnSelected(){}
simulated event OnSelected(){}
simulated function OnIsUnitOutside(SeqAct_IsUnitOutside Action){}
simulated function OnIsSelectedUnit(SeqAct_IsSelectedUnit Action){}
simulated function OnAbortCurrentAction(SeqAct_AbortCurrentAction Action){}
simulated function bool isSelected(){}
simulated function SetCurrentWeapon(XComWeapon kWeapon){}
simulated function EquipWeapon(XComWeapon kWeapon, bool bImmediate, bool bIsRearBackPackItem){}
simulated function AttachItem(Actor A, name SocketName, bool bIsRearBackPackItem, out MeshComponent kFoundMeshComponent){}
simulated function DetachItem(MeshComponent MeshComp){}
simulated function bool GetFireSocket(out Vector vLoc, out Rotator rRot){}
simulated function Rotator GetAimError(Vector vTarget){}
simulated function DisableAimOffset(){}
simulated function EnableAimOffset(){}
simulated function SmoothAimAtTarget(float dt, Vector vTarget, optional bool bTurn=TRUE){}
simulated function LogDebugInfo(){}
simulated function Vector GetNoTargetLocation(optional bool bThirdPerson=true){}
simulated function Vector GetHeadshotLocation(){}
simulated function Vector GetFeetLocation(){}
simulated function Vector GetPsiSourceLocation(){}
simulated function bool CalcCamera(float DeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV){}
simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc){}
simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon){}
simulated function AttachRangeIndicator(float fDiameter, StaticMesh kMesh){}
simulated function DetachRangeIndicator(){}
simulated function AttachKineticStrikeIndicator(float fDiameter, StaticMesh kMesh){}
simulated function DetachKineticStrikeIndicator(){}
simulated function AttachFlamethrowerIndicator(float fDiameter, StaticMesh kMesh){}
simulated function DetachFlamethrowerIndicator(){}
simulated function ParticleSystemComponent GetMindMergeSendFX(int iIndex){}
simulated function CHEAT_InitPawnPerkContent(const TCharacter Char){}
simulated function InitPawnPerkContent(const TCharacter Char){}
simulated function array<int> GetAllPossiblePerkContent(){}
simulated function XComPerkContent GetPerkContent(EPerkType Perk){}
simulated function StartPersistentPawnPerkFX(){}
simulated function StopPersistentPawnPerkFX(){}
event EncroachedBy(Actor Other){}
function bool ShouldTearOffOnDeath();
function SetDyingPhysics(){}
simulated function OnDeathDeactivateEffects();
singular simulated event OutsideWorldBounds(){}
simulated event FellOutOfWorld(class<DamageType> dmgType){}
function DoDeathOnOutsideOfBounds(){}
simulated function ResetPositionForDeath(bool bSnapToGround){}
simulated function bool SnapToGround(optional float Distance=1024.0){}
simulated function SetupForMatinee(optional Actor MatineeBase, optional bool bDisableFootIK, optional bool bDisableGenderBlender){}
simulated function ReturnFromMatinee(){}
simulated event BeginAnimControl(InterpGroup InInterpGroup){}
simulated event FinishAnimControl(InterpGroup InInterpGroup){}
simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst){}
simulated event InterpolationFinished(SeqAct_Interp InterpAction){}
simulated event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay){}
simulated event UnMountCinematicFaceFX(){}
simulated event FaceFXAsset GetActorFaceFXAsset(){}
simulated function SoundNodeWave GetWavNode(SoundCue SndCue, optional SoundNode SndNode){}
simulated function bool IsPawnReadyForViewing(){}
simulated event Speak(SoundCue Cue){}
simulated function StopCommLink(){}
simulated function RotateInPlace(int Dir);
function DelayedDeathSound();
simulated function PerformShotAbility(){}
simulated function DebugVis(Canvas kCanvas, XComCheatManager kCheatManager){}
simulated function DebugIK(Canvas kCanvas, XComCheatManager kCheatManager){}
simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, Vector vCameraPosition, Vector vCameraDir);
simulated function UpdateAllMeshMaterials(){}
simulated function float SetGhostFX(bool bShouldGhost){}
simulated event ApplyGhostMaterials(MaterialInstanceTimeVarying MITV){}
simulated function CleanUpGhostFX(){}
simulated event ReplicatedEvent(name VarName){}

simulated state NoTicking{}
simulated state RagDollBlend{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    simulated function FinishRagDollExternal(){}
    simulated function FinishRagDoll(){}
    simulated function GoToNextState(){}
    simulated event Tick(float dt){}
    simulated function BreakFragile(){}
}

state WaitingToBeDestroyed{
    event BeginState(name PreviousStateName){}
    event EndState(name NextStateName){}
    simulated function AttemptToDestroy(){}
}

simulated state Dying{

    simulated event Timer(){}
    simulated event BeginState(name PreviousStateName){}
}

defaultproperties
{
	Components(0)=none
	Components(1)=none
	begin object class=CylinderComponent name=UnitCollisionCylinder 
		CollisionRadius=14.0
		RBChannel=RBCC_Pawn
		HiddenGame=false
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=false
		CanBlockCamera=true
		BlockRigidBody=true
		RBCollideWithChannels=(Default=true,Vehicle=true,Water=true,GameplayPhysics=true,EffectPhysics=true,Untitled1=true,Untitled2=true,Untitled3=true,Untitled4=true,Cloth=true,FluidDrain=true,SoftBody=true,BlockingVolume=true,DeadPawn=true)
	end object
	Components.Add(UnitCollisionCylinder)
	CylinderComponent=UnitCollisionCylinder
	CollisionComponent=UnitCollisionCylinder

    begin object class=DynamicLightEnvironmentComponent name=MyLightEnvironment
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
	Components.Add(MyLightEnvironment)
	LightEnvironment=MyLightEnvironment

	begin object class=SkeletalMeshComponent name=SkeletalMeshComponent 
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
	Components.Add(SkeletalMeshComponent)
	Mesh=SkeletalMeshComponent

    begin object class=StaticMeshComponent name=RangeIndicatorMeshComponent
        ReplacementPrimitive=none
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
	Components.Add(RangeIndicatorMeshComponent)
	RangeIndicator=RangeIndicatorMeshComponent

	begin object class=ParticleSystemComponent name=MindMergeFX_Send0 
        bAutoActivate=false
        bIgnoreOwnerHidden=true
    end object
	Components.Add(MindMergeFX_Send0)
	MindMergeFX_Send=MindMergeFX_Send0

    begin object class=ParticleSystemComponent name=MindMergeFX_Receive0
        bAutoActivate=false
    end object
	Components.Add(MindMergeFX_Receive0)
	MindMergeFX_Receive=MindMergeFX_Receive0

    begin object class=ParticleSystemComponent name=PsiPanicFX_Receive0
        bAutoActivate=false
	end object
	Components.Add(PsiPanicFX_Receive0)
	PsiPanicFX_Receive=PsiPanicFX_Receive0

    begin object class=ParticleSystemComponent name=MindFrayFX_Receive0
        bAutoActivate=false
    end object
	Components.Add(MindFrayFX_Receive0)
	MindFrayFX_Receive=MindFrayFX_Receive0

    begin object class=ParticleSystemComponent name=MindControlFX_Send0
        bAutoActivate=false
        bIgnoreOwnerHidden=true
    end object
	Components.Add(MindControlFX_Send0)
	MindControlFX_Send=MindControlFX_Send0

    begin object class=ParticleSystemComponent name=MindControlFX_Receive0
        bAutoActivate=false
	end object
	Components.Add(MindControlFX_Receive0)
	MindControlFX_Receive=MindControlFX_Receive0

    begin object class=ParticleSystemComponent name=PsiInspiredFX_Receive0
        bAutoActivate=false
	end object
	Components.Add(PsiInspiredFX_Receive0)
	PsiInspiredFX_Receive=PsiInspiredFX_Receive0

    begin object class=ParticleSystemComponent name=DisablingShot_Receive0
        bAutoActivate=false
	end object
	Components.Add(DisablingShot_Receive0)
	DisablingShot_Receive=DisablingShot_Receive0

    begin object class=ParticleSystemComponent name=StunShot_Receive0
        bAutoActivate=false
	end object
	Components.Add(StunShot_Receive0)
	StunShot_Receive=StunShot_Receive0

    begin object class=ParticleSystemComponent name=TracerBeamed
        bAutoActivate=false
	end object
	TracerBeamedFX=TracerBeamed

    begin object  class=ParticleSystemComponent name=PoisonedByChryssalid
        bAutoActivate=false
	end object
	PoisonedByChryssalidFX=PoisonedByChryssalid

    begin object class=ParticleSystemComponent name=PoisonedByThinman
        bAutoActivate=false
	end Object
	PoisonedByThinmanFX=PoisonedByThinman

    begin object class=ParticleSystemComponent name=Electropulsed
        bAutoActivate=false
	end object
	ElectropulsedFX=Electropulsed

    LocalCameraOffset=(X=-50.0,Y=38.0,Z=0.0)
    CameraFocusDistance=6400.0
    AimLimit=(X=12000.0,Y=6000.0)
    AimSpeedFactor=0.000250
    AimStopThreshold=500.0
    AimSpeedMin=0.050
    AimSpeedMax=2.0
    AimAtTargetMissPercent=1.0
    TurnSpeedMultiplier=1.0
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
    m_fPercent=100.0
    MaxStepHeight=48.0
    WalkableFloorZ=0.10
    bPushesRigidBodies=true
    MeleeRange=128.0
    GroundSpeed=1.0
    BaseEyeHeight=40.0
	RBPushRadius=8.0
    RBPushStrength=5.0
    bBlockActors=false
    RotationRate=(Pitch=20000,Yaw=40000,Roll=20000)
	ControllerClass=none
}