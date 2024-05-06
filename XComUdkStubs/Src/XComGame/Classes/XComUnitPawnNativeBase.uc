class XComUnitPawnNativeBase extends XComPawn
    native(Unit)
    nativereplication
    config(Game)
    hidecategories(Navigation);

const CYBERDISC_OPENCLOSE_DELAY = 0.5f;
const MAX_HIDDEN_TIME = 4.0f;

enum ETimeDilationState
{
    ETDS_None,
    ETDS_VictimOfOverwatch,
    ETDS_ReactionFiring,
    ETDS_TriggeredPodActivation,
    ETDS_MAX
};

struct native FootIKInfo
{
    var SkelControlFootPlacement FootIKControl;
    var int FootIKBoneIndex;
    var AnimNotify_BlendIK.BlendIKType FootIKBlendType;
    var Vector vCachedFootPos;
    var float vCachedHitZ;
};

struct native PawnPerkContent
{
    var XComPerkContent kContent;
    var EPerkType ePerk;
};

struct native TUnitPawnOpenCloseStateReplicationData
{
    var EUnitPawn_OpenCloseState m_eOpenCloseState;
    var bool m_bImmediate;
};

var XComAnimNodeWeaponState WeaponStateNode;
var AnimNode_MultiBlendPerBone OpenCloseStateNode;
var AnimNodeBlendPerBone FlyingLegMaskNode;
var XComAnimNodeBlendByMovementType MovementNode;
var XComAnimNodeBlendSynchTurning TurnNode;
var AnimNodeBlendList CrouchNode;
var XComAnimNodeBlendByAction ActionNode;
var AnimNodeMirror MirrorNode;
var XComAnimNodeIdle IdleNode;
var array<XComAnimNodeCover> CoverNodes;
var array<AnimNodeAdditiveBlending> WeaponDownNodes;
var array<AnimNodeAdditiveBlending> SuppressedNodes;
var array<AnimNodeBlendPerBone> SpineMaskNodes;
var float m_fTurnInitialTargetDirAngle;
var bool m_bTurnFinished;
var() bool bSkipIK;
var bool bSelfFlankedSystemOK;
var bool m_bLeftHandIKEnabled;
var bool m_bLeftHandIKAnimOverrideEnabled;
var bool m_bLeftHandIKAnimOverrideOn;
var bool bLatent_FinishAnimateSwitchCoverSides;
var bool bUseObstructionShader;
var(XComUnitPawn) bool bAllowFireFromSuppressIdle;
var(XComUnitPawn) bool bAllowOnlyLowCoverAnims;
var bool bSkipRotateToward;
var() bool m_bUseRMA;
var bool m_bShouldTurnBeforeMoving;
var bool m_bAuxParametersDirty;
var bool m_bAuxParamNeedsPrimary;
var bool m_bAuxParamNeedsSecondary;
var bool m_bAuxParamUse3POutline;
var bool m_bAuxAlwaysVisible;
var private bool m_bAuxParamNeedsAOEMaterial;
var bool m_bNewNeedsAOEMaterial;
var private bool m_bTexturesBoosted;
var bool m_bWaitingToTurnIntoZombie;
var float m_fTurnLocInterpAmount;
var Vector m_vTurnInitialLocation;
var int m_iAimActiveChild;
var XComAnimNodeAiming AimingNode;
var Vector2D AimOffset;
var AnimNodeBlend StandingAimToggle;
var AnimNodeAimOffset StandingAimOffsetNode;
var AnimNodeAimOffset LowCoverAimOffsetNode;
var AnimNodeAimOffset HighCoverAimOffsetNode;
var AnimNodeBlendList CrouchStateNode;
var EDiscState m_ePreDiscHoverState;
var XGUnitNativeBase.ECoverState LatentSwitchSidesCoverState;
var XComAnimNodeWeaponState.EAnimWeaponState m_eWeaponState;
var transient XComAnimNodeBlendByExitCoverType.EExitCoverTypeToUse m_eLastSelectedExitCoverType;
var EUnitPawn_OpenCloseState m_eOpenCloseState;
var ETimeDilationState m_eTimeDilationState;
var transient ELocation m_eMoveItemToSlot;
var float fFootIKTimeLeft;
var array<FootIKInfo> FootIKInfos;
var array<int> abColCylEnable;
var SkelControlLimb LeftHandIK;
var SkelControlLimb RightHandIK;
var Vector FocalPoint;
var Vector vMoveDirection;
var Vector vMoveDestination;
var Vector LatentTurnTarget;
var float fBaseZMeshTranslation;
var array<PawnPerkContent> arrPawnPerkContent;
var Vector m_vFireLoc;
var float m_fTotalDistanceAlongPath;
var float m_fDistanceMovedAlongPath;
var float m_fDistanceToStopExactly;
var int m_iLastInterval_MoveReactionProcessing;
var XComStairVolume m_StairVolume;
var protectedwrite repnotify XGUnitNativeBase m_kGameUnit;
var(XComUnitPawn) array<AnimSet> DefaultUnitPawnAnimsets;
var(XComUnitPawn) array<AnimSet> CustomFlightMovementRifleAnimsets;
var(XComUnitPawn) array<AnimSet> CustomFlightMovementPistolAnimsets;
var(XComUnitPawn) float PathingRadius;
var(XComUnitPawn) float CollisionHeight;
var(XComUnitPawn) float CollisionRadius;
var(XComUnitPawn) Vector ThrowGrenadeStartPosition;
var(XComUnitPawn) Vector ThrowGrenadeStartPositionUnderhand;
var float fStopDistanceNoCover;
var float fStopDistanceCover;
var protectedwrite repnotify TUnitPawnOpenCloseStateReplicationData m_kOpenCloseStateReplicationData;
var(XComUnitPawn) editinline array<editinline AnimNotify_PlayParticleEffect> m_arrParticleEffects;
var name m_WeaponSocketNameToUse;
var(XComUnitPawn) array<ELocation> HiddenSlots;
var Vector TargetLoc;
var() name HeadBoneName;
var(XComUnitPawn) float FocusFireBlendTime;
var MaterialInstance m_kAuxiliaryMaterial;
var MaterialInterface m_kAuxiliaryMaterial_ZeroAlpha;
var LightingChannelContainer m_DefaultLightingChannels;
var MaterialInstance m_kAOEMaterial;
var float m_fPercent;
var float m_fVisibilityPercentage;
var int m_iTurnsTillVisibilityCheck;
var(BlendTimes) float Movement_Stop_Blend;
var(BlendTimes) float Into_Idle_Blend;
var(BlendTimes) float Start_Turn_Blend;
var(BlendTimes) float Start_Strangle_Blend;
var(BlendTimes) float Stop_Strangle_Blend;
var(BlendTimes) float Kill_Strangle_Blend;
var const MaterialInstance HumanGlowMaterial;
var const MaterialInstance AlienGlowMaterial;
var const MaterialInstance CivilianGlowMaterial;
var Material AOEHitMaterial;
var export editinline SkeletalMeshComponent m_kKitMesh;
var export editinline SkeletalMeshComponent m_kHeadMeshComponent;
var protectedwrite export editinline SkeletalMeshComponent HairComponent;
var export editinline array<export editinline ParticleSystemComponent> m_arrRemovePSCOnDeath;
var transient XComWeapon m_kMoveItem;
var array<XComDestructibleActor> NearbyFragileDestructibles;
var DamageEvent DamageEvent_CauseOfDeath;

defaultproperties
{
    m_bTurnFinished=true
    bUseObstructionShader=true
    PathingRadius=19.0
    CollisionHeight=64.0
    CollisionRadius=14.0
    ThrowGrenadeStartPosition=(X=-12.9280,Y=33.7270,Z=111.3980)
    ThrowGrenadeStartPositionUnderhand=(X=46.80,Y=23.9960,Z=27.3950)
    m_WeaponSocketNameToUse=gun_fire
    HiddenSlots(0)=200
    FocusFireBlendTime=0.250
    Movement_Stop_Blend=0.250
    Into_Idle_Blend=0.250
    Start_Turn_Blend=0.10
    Start_Strangle_Blend=0.10
    Stop_Strangle_Blend=0.10
    Kill_Strangle_Blend=0.250
    HumanGlowMaterial=MaterialInstanceConstant'FX_Visibility.Materials.MInst_HumanGlow'
    AlienGlowMaterial=MaterialInstanceConstant'FX_Visibility.Materials.MInst_AlienGlow'
    CivilianGlowMaterial=MaterialInstanceConstant'FX_Visibility.Materials.MInst_CivilianGlow'
    DamageEvent_CauseOfDeath=(DamageAmount=0,EventInstigator=none,HitLocation=(X=0.0,Y=0.0,Z=0.0),Momentum=(X=0.0,Y=0.0,Z=0.0),DamageType=none,HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName=None,HitComponent=none),DamageCauser=none,bRadialDamage=false,Radius=0.0,bIsHit=false,IgnoredActors=none,Target=none,bDamagesUnits=true,bCausesSurroundingAreaDamage=true,bDebug=false,FilterBox=(Min=(X=0.0,Y=0.0,Z=0.0),Max=(X=0.0,Y=0.0,Z=0.0),IsValid=0),kShot=none)
    m_bReplicateHidden=false
    bAlwaysRelevant=true
}