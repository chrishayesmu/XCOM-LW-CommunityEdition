class XComUnitPawnNativeBase extends XComPawn
	native(Unit)
    nativereplication
    config(Game)
	dependson(XGUnitNativeBase)
	dependson(XComAnimNodeWeaponState)
	dependson(XComAnimNodeBlendByExitCoverType)
	dependson(AnimNotify_MEC)
	dependson(XComAnimNodeUnitStairState);

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
    var BlendIKType FootIKBlendType;
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
var bool m_bAuxParamNeedsAOEMaterial;
var bool m_bNewNeedsAOEMaterial;
var bool m_bTexturesBoosted;
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
var ECoverState LatentSwitchSidesCoverState;
var EAnimWeaponState m_eWeaponState;
var transient EExitCoverTypeToUse m_eLastSelectedExitCoverType;
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
var repnotify XGUnitNativeBase m_kGameUnit;
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
var export editinline SkeletalMeshComponent HairComponent;
var export editinline array<export editinline ParticleSystemComponent> m_arrRemovePSCOnDeath;
var transient XComWeapon m_kMoveItem;
var array<XComDestructibleActor> NearbyFragileDestructibles;
var DamageEvent DamageEvent_CauseOfDeath;

replication
{
    if((Role == ROLE_Authority) && bNetDirty)
        m_fTotalDistanceAlongPath, m_kGameUnit, 
        m_kOpenCloseStateReplicationData;
}

native function FadeOutPawnSounds();
native function FadeInPawnSounds();
simulated event PostBeginPlay(){}
native simulated function UpdateAuxParameterState(bool bDisable3POutline);
native function ComputeFireLoc();
native function EAnimUnitStairState GetStairState();
simulated function SetGameUnit(XGUnit kGameUnit){}
simulated function InitializeParticleFXTemplates();
native simulated function XGUnitNativeBase GetGameUnit();
native simulated function bool IsUnitFullyComposed(optional bool bBoostTextures=true);
native simulated function ForceBoostTextures();
native function BuildFootIKData();
native function PushCollisionCylinderEnable(bool bEnable);
native function PopCollisionCylinderEnable();
reliable client simulated function UnitSpeak(ECharacterSpeech eCharSpeech);
simulated event ReplicatedEvent(name VarName){}
simulated function bool IsInitialReplicationComplete(){}
native simulated function CalculateVisibilityPercentage();
native simulated function SetVisibilityPercentage(float Percent);
native simulated function UpdateOccludedUnitShader(float Percent);
native simulated function ProcessTimeDilation(float DeltaTime);
simulated function UpdateAllMeshMaterials();
simulated function UpdateMeshMaterials(MeshComponent MeshComp);
native simulated function MarkAuxParametersAsDirty(bool bNeedsPrimary, bool bNeedsSecondary, bool bUse3POutline);
protected simulated function SetAuxParameters(bool bNeedsPrimary, bool bNeedsSecondary, bool bUse3POutline){}
protected native simulated function SetAuxParametersNative(bool bNeedsPrimary, bool bNeedsSecondary, bool bUse3POutline);
protected native simulated function CreateAuxMaterial();
native final simulated function UpdateAndReattachComponent(SkeletalMeshComponent SkelMeshComp, bool bNeedsPrimary, bool bNeedsSecondary, bool bUse3POutline, optional bool bReattach=true);
simulated event SetCoverNodeAnimationState(float BlendTime){}
simulated function EnableFootIK(bool bEnable){}
simulated function CheckSelfFlankedSystem(){}
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){}
native function float ComputeAnimationRMADistance(name AnimSeqName);
simulated function string GetPawnAimProfileString(EPawnType currentPawnType){}
simulated function UpdateAimProfile(optional string DirectRequest){}
simulated function UpdateAimProfileForSuppression(){}
simulated exec function UpdateAnimations(){}
simulated function bool XComIsOpenCloseStateNodeClosed(){}
simulated function bool XComUpdateOpenCloseStateNode(XGTacticalGameCoreData.EUnitPawn_OpenCloseState eDesiredState, optional bool bImmediate){}
simulated function XComUpdateAnimSetList(){}
final simulated function XComAddAnimSets(const out array<AnimSet> CustomAnimSets){}
simulated event bool RestoreAnimSetsToDefault(){}
simulated event PlayMECEventSound(AnimNotify_MEC.EMECEvent Event);
simulated event FireWeapon(){}
simulated event FireWeaponCustom(name weaponsocket, optional int TemplateIndex, optional int WeaponIndex, optional AnimNodeSequence NodeSeq, optional AnimNotify Notify, optional bool bCanDoDamage=true, optional int PerkIndex){}
simulated event BreakWindow(){}
simulated event KickDoor(){}
function ReclaimCoverPostDoorKick(){}
function SetStairVolume(XComStairVolume StairVolume){}
native simulated function SetMoveAnimRMA(bool bEnabled);
simulated event Destroyed(){}
simulated event DoFireDamage(){}
simulated event SetFocalPoint(Vector vFocalPt){}
function bool OnMouseEvent(int Cmd, int Actionmask, optional Vector MouseWorldOrigin, optional Vector MouseWorldDirection, optional Vector HitLocation){}
simulated function ResetMaterials(){}
simulated function ResetWeaponMaterials(){}
simulated event ApplyGhostMaterials(MaterialInstanceTimeVarying MITV);
simulated function CleanUpGhostFX();
simulated event Vector GetLeftHandIKTargetLoc();
simulated event MoveToGroundAfterDestruction(){}
simulated event StartTurning(Vector Target, bool bSetMoveNodeToTurn, optional bool bIgnoreMovingCursor){}
simulated event StopTurning(bool bSetMoveNodeToStationary, optional bool bSetRotation=true){}
simulated function bool IsInStrategy(){}
simulated function EnableRMA(bool bEnableRMATranslation, bool bEnableRMARotation, optional bool bUpdateFocalPoint=true){}
simulated function bool IsRMAEnabled(){}
simulated function Helper_EnableRMATranslation(bool bEnable){}
simulated function Helper_EnableRMARotation(bool bEnable, bool bUpdateFocalPoint){}
event bool PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData){}
function bool NotifyPSCWantsRemoveOnDeath(ParticleSystemComponent PSC){}
simulated function SkelMeshActorOnParticleSystemFinished(ParticleSystemComponent PSC){}
native simulated function SetSuppressionNodes(bool bSuppressed, float BlendTime);
simulated function SetWaitingToBeZombified(bool bIsWaitingToZombify){}

defaultproperties
{
	Components(0)=none
}
