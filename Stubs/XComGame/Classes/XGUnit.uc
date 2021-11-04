class XGUnit extends XGUnitNativeBase
    config(GameCore)
    notplaceable
    hidecategories(Navigation)
	DependsOn(XGTacticalGameCoreNativeBase)
	dependson(XGSightManagerNativeBase)
	dependson(XGAIChryssalidEgg);
//complete stub

const EXITCOVERANGLE_ZERO = 0.7f;
const EXITCOVERANGLE_NINETY = -0.7f;
const MAX_NUM_VOLUMES = 16;
const MAX_ZOMBIE_MORALE_LOSS = 3;
const RECENT_VOICE_TIME = 10.0f;
const MAX_STUN_RANGE_INDICATION = 400;
const MASSIVE_AMOUNT_OF_DAMAGE = 1000000;

enum EAttentionNeeded
{
    eAttention_Panic,
    eAttention_Poison,
    eAttention_RapidRegen,
    eAttention_NeuralDamping,
    eAttention_RepairServos,
    eAttention_RegenPheromones,
    eAttention_Strangle,
    eAttention_ShivRepair,
    eAttention_MAX
};

struct CheckpointRecord_XGUnit extends CheckpointRecord
{
    var bool m_bMoraleLevelChanged;
    var array<EMoraleEvent> m_arrMoraleEventsThisTurn;
    var deprecated ECoverType m_aCover[ECoverDir];
    var deprecated Actor m_aCoverObject[ECoverDir];
    var deprecated Vector m_avCoverPoint[ECoverDir];
    var int m_iCriticalWoundCounter;
    var int m_iCoverBits;
    var EDiscState m_eDiscState;
    var XComAlienPod m_kPod;
    var bool m_bSuppressing;
    var bool m_bSuppressingArea;
    var bool m_bCanTakeCover;
    var bool m_bWasKilledByExplosion;
    var float m_fAutoFiringRate;
    var XGUnit m_kForceConstantCombatTarget;
    var bool m_bFailedCloseCombatCheck;
    var bool m_bHasBeenBerserk;
    var Actor m_kReplicatedOwner;
    var bool m_bInDropShip;
    var bool m_bLeftBehind;
    var int m_iLowestHP;
    var int m_iFreeTurns;
    var array<XGUnit> m_arrCloseCombatShots;
    var int m_iNumVolumes;
    var XGVolume m_aVolumes[16];
    var XGVolume m_kTelekineticVolume;
    var XGVolume m_kRiftVolume;
    var int m_aPanicModifier[ECharacterStat];
    var int m_iZombieMoraleLoss;
    var int m_iLastIntimidateTurn;
    var int m_iBWAimPenalty;
    var int m_iBWMobPenalty;
    var TAppearance m_SavedAppearance;
    var bool m_bPoisonedByThinman;
    var XGLoadoutInstances m_kLoadoutInstances;
    var XGAIChryssalidEgg m_kEgg;
    var EUnitPawn_OpenCloseState m_ePawnOpenCloseState;
    var XGUnit m_kZombieVictim;
    var int m_iUsedSecondaryHeart;
    var int m_iRepairServosHPLeft;
    var int m_iDamageControlTurns;
    var bool m_bFiredReactiveTargeting;
    var bool m_bHadShieldThisTurn;
    var int m_iWillCheatBonus;
    var bool m_bCovertHackerThisTurn;
    var bool m_bCorpseWasHidden;
    var string m_strCauseOfDeath;
};

struct ReplicateWeaponSwapData
{
    var XGWeapon m_kSwitchFromWeapon;
    var XGWeapon m_kSwitchToWeapon;
};

struct ReplicateActivatePerkData
{
    var EPerkType m_ePerkType;
    var XGUnit m_kPrimaryTarget;
    var XGUnit m_arrAdditionalTargets[EXGAbilityNumTargets];
    var XGUnit m_kNeuralFeedbackTarget;
    var int m_iNeuralFeedbackDamage;
};

var bool m_bUnstealthingWhileFiring;
var bool m_bDiedWhileFiring;
var bool m_bCriticallyWoundedWhileFiring;
var bool m_bMoraleLevelChanged;
var bool m_bSuppressing;
var bool m_bSuppressingArea;
var bool m_bCanTakeCover;
var bool m_bInDropShip;
var bool m_bLeftBehind;
var bool m_bHasBeenBerserk;
var bool m_bWasKilledByExplosion;
var bool m_bMadeNoise;
var bool m_bIsDoingBullRush;
var bool m_bHiddenOnDeath;
var bool m_bDidRushCam;
var bool m_bBloodlustMove;
var bool m_bApplyingNeuralFeedback;
var bool m_bHitNeuralFeedbackTarget;
var bool m_bCorpseWasHidden;
var bool m_bCanOpenWindowsAndDoors;
var bool m_bPoisonedByThinman;
var bool m_bInfiniteGrenades;
var bool m_bShowMouseOverDisc;
var bool m_bIgnoreCloseCombatNextMove;
var bool m_bWaitForCloseCombatDamage;
var bool m_bFailedCloseCombatCheck;
var bool m_bSeenBetterAlien;
var bool m_bAddClientsidePathAction;
var repnotify bool m_bReactionFireAutoZoomAddSelf;
var repnotify bool m_bPushStatePanicking;
var bool m_bGotoStateInactiveFromStatePanicked;
var bool m_bActivateAfterPanickedComplete;
var bool m_bPanicMoveFinished;
var bool m_bServerPanicMoveFinished;
var bool bForcePanicMove;
var bool m_bDeathExplosionDone;
var bool m_bClickActivated;
var bool m_bSkipTrackMovement;
var bool m_bFiredReactiveTargeting;
var bool m_bAbsorptionFieldsWorked;
var bool m_bCovertHackerThisTurn;
var bool m_bHadShieldThisTurn;
var bool m_bCheckedItemInfos;
var bool m_bCheckedWeaponInfos;
var bool m_bStrangleLoopStarted;
var bool m_bOverrideOverwatch;
var bool m_bOverrideOverwatchForceHit;
var bool m_bOverrideOverwatchForceMiss;
var bool bIgnoreMoralEvents;
var int m_bCantBeHurt;
var transient bool m_bMPForceDeathOnMassiveTakeDamage;
var array<EMoraleEvent> m_arrMoraleEventsThisTurn;
var int m_iNeuralFeedbackDamage;
var XGUnit m_kNeuralFeedbackTarget;
var Vector m_vNoiseLoc;
var string m_sDefenseImage;
var string m_sOffenseImage;
var string m_sDamageImage;
var string m_sCriticalDamageImage;
var XGAIChryssalidEgg m_kEgg;
var XComAlienPod m_kPod;
var XGUnit m_kZombieVictim;
var int m_iCriticalWoundCounter;
var int m_iLowestHP;
var int m_iFreeTurns;
var array<XGUnit> m_arrCloseCombatShots;
var int m_iWillCheatBonus;
var int m_iCoverBits;
var repnotify XGPlayer m_kPlayer;
var repnotify Actor m_kReplicatedOwner;
var repnotify XGLoadoutInstances m_kLoadoutInstances;
var XGCameraView_Unit m_kUnitView;
var repnotify EDiscState m_eDiscState;
var EUnitPawn_OpenCloseState m_ePawnOpenCloseState;
var repnotify EPerkType m_eReplicateDeactivatePerkType;
var export editinline StaticMeshComponent m_kDiscMesh;
var export editinline StaticMeshComponent m_kBoxMesh;
var MaterialInstanceTimeVarying m_kBoxMeshUnitSelectMaterial;
var MaterialInstanceTimeVarying m_kBoxMeshEnemySelectMaterial;
var export editinline StaticMeshComponent m_kFlyingRing;
var TextureFlipBook m_kDiscAnim;
var export editinline StaticMeshComponent m_kSightRing;
var export editinline SpriteComponent m_kSightRingIcon;
var string m_strCauseOfDeath;
var float m_fAutoFiringRate;
var XGUnit m_kForceConstantCombatTarget;
var XGUnit LastHitTarget;
var XGUnit m_kWhiplashCredit;
var XGUnit m_kFirstKillTarget;
var int m_iBindNextPathActionToClientProxyActionID;
var XGAction_Path m_kOldClientsidePathAction;
var int m_iNumVolumes;
var XGVolume m_aVolumes[16];
var XGVolume m_kTelekineticVolume;
var XGVolume m_kRiftVolume;
var array<ECharacterSpeech> m_arrRecentSpeech;
var float m_fElapsedRecentSpeech;
var repnotify XGUnit m_kReactionFireAutoZoomTarget;
var XGUnit m_kStrangleTarget;
var array<string> m_arrLastPlayedAnims;
var int LastPlayedAnimCounter;
var array<string> m_arrStrDebugReaction;
var int m_aPanicModifier[ECharacterStat];
var ForceFeedbackWaveform m_kPanicFF;
var ForceFeedbackWaveform m_arrPanicFF[2];
var int m_iZombieMoraleLoss;
var int m_iUnitLoadoutID;
var XGUnit m_kDamageDealer;
var int m_iLastIntimidateTurn;
var int m_iBWAimPenalty;
var int m_iBWMobPenalty;
var int m_iUsedSecondaryHeart;
var int m_iRepairServosHPLeft;
var int m_iDamageControlTurns;
var int m_iCovertOpKills;
var MaterialInterface Cursor_UnitSelectEnterFB_MaterialInterface;
var MaterialInterface Cursor_UnitSelectExitFB_MaterialInterface;
var MaterialInterface Cursor_UnitSelectIdle_MITV;
var MaterialInterface Cursor_UnitSelectTargeted_MITV;
var TextureFlipBook UnitCursor_CirclesEnter;
var TextureFlipBook UnitCursor_CirclesExit;
var MaterialInterface UnitCursor_UnitSelect_Gold;
var MaterialInstanceConstant UnitCursor_UnitSelect_Green;
var MaterialInterface UnitCursor_UnitSelect_Orange;
var MaterialInterface UnitCursor_UnitSelect_Purple;
var MaterialInterface UnitCursor_UnitSelect_RED;
var MaterialInterface UnitCursor_UnitCursor_Flying;
var MaterialInstanceConstant UnitCursor_FlyingEffectMaterial;
var export editinline ParticleSystemComponent RiftPSC;
var export editinline ParticleSystemComponent RiftEndPSC;
var export editinline ParticleSystemComponent TKFieldPSC;
var export editinline ParticleSystemComponent TKFieldEndPSC;
var export editinline ParticleSystemComponent BattleScannerPSC;
var export editinline ParticleSystemComponent BattleScannerEndPSC;
var TAppearance m_SavedAppearance;
var array<EItemType_Info> m_arrItemInfos;
var array<EItemType_Info> m_arrWeaponInfos;
var const localized string m_strUnitStunned;
var const localized string m_strNewAbilityAlienDevice;
var const localized string m_strHoverNoLand;
var const localized string m_strHoverLanded;
var const localized string m_strHoverNoLandAI;
var const localized string m_strHoverLandedAI;
var const localized string m_strReloading;
var const localized string m_strRift;
var const localized string m_sExplosiveDamageDisplay;
var const localized string m_sCriticalHitDamageDisplay;
var int m_iOverrideOverwatchDamage;
var repnotify ReplicateWeaponSwapData m_kReplicateWeaponSwapData;
var repnotify int m_iAddUnitFlag;
var repnotify ReplicateActivatePerkData m_kReplicateActivatePerkData;
var array<EAttentionNeeded> m_arrAttentionNeeds;
//var delegate<CoverValidator> __CoverValidator__Delegate;

replication
{
    if((bNetOwner && bNetInitial) && Role == ROLE_Authority)
        m_kReplicatedOwner;

    if(bNetDirty && Role == ROLE_Authority)
        m_aVolumes, m_bCanOpenWindowsAndDoors, 
        m_bDeathExplosionDone, m_bFailedCloseCombatCheck, 
        m_bGotoStateInactiveFromStatePanicked, m_bInDropShip, 
        m_bPushStatePanicking, m_bReactionFireAutoZoomAddSelf, 
        m_bSeenBetterAlien, m_bServerPanicMoveFinished, 
        m_bSuppressing, m_bSuppressingArea, 
        m_eDiscState, m_eReplicateDeactivatePerkType, 
        m_fAutoFiringRate, m_iAddUnitFlag, 
        m_iBWAimPenalty, m_iBWMobPenalty, 
        m_iCriticalWoundCounter, m_iLowestHP, 
        m_iNumVolumes, m_kForceConstantCombatTarget, 
        m_kLoadoutInstances, m_kPlayer, 
        m_kReactionFireAutoZoomTarget, m_kReplicateActivatePerkData;

    if(!bNetOwner && Role == ROLE_Authority)
        m_kReplicateWeaponSwapData;
}
simulated function bool HasRegenPheromonesTargets(){}
simulated function bool UnitNeedsAttentionStartingTurn(){}
simulated function bool UnitNeedsAttentionEndingTurn(){}
simulated function bool UnitHasAttention(){}
simulated function CopyBuffsToDynamicArray(out array<int> recipientArr, const out int buffDistribute[EPerkType]){}
simulated function array<int> GetPassivePerkList(){}
simulated function array<int> GetBonusesPerkList(){}
simulated function array<int> GetPenaltiesPerkList(){}
simulated function array<EItemType_Info> GetItemInfos(){}
simulated function array<EItemType_Info> GetWeaponInfos(){}
simulated function EItemType_Info GetMecWeaponItemInfo(EItemType eWeapon){}
function SetActorTemplateInfo(out ActorTemplateInfo TemplateInfo){}
function CreateCheckpointRecord(){}
simulated function UpdatePsiEffects(){}
simulated function ParticleSystemComponent GetPsiEffect(int iType, bool bSender, optional int iIndex=0){}
simulated event EndPsiEffect(XGAbility_Targeted kPsiAbility){}
simulated function UpdatePsiReceiving(XGAbility_Targeted kPsiAbility){}
simulated function UpdatePsiSending(XGAbility_Targeted kPsiAbility){}
simulated function UpdatePsiSendEffect(XGUnit kTarget, ParticleSystemComponent kPS){}
simulated function KillMindMergeTargets(Weapon kDroppedWeapon, XGUnit kCredit){}
simulated event ReplicatedEvent(name VarName){}
simulated function AddDynamicWeaponToClientInventory(out TDynamicSpawnedWeaponReplicationInfo kInfo, name nameOfStruct){}
simulated function DynamicWeaponReplicationPoll(out TDynamicSpawnedWeaponReplicationInfo kInfo, name UIDPollFunc){}
simulated function IsInitialReplicationComplete_SmokeGrenade(){}
simulated function IsInitialReplicationComplete_BattleScanner(){}
simulated function bool IsInitialReplicationComplete(){}
simulated function DisableMirroring(){}
simulated function EnableMirroring(){}
function bool DestroyOnBadLocation(){}
simulated function StartProvidingCover(optional bool bInitiatedByAbility=FALSE){}
simulated function StopProvidingCover(){}
simulated function ProcessNewPosition(optional bool bEvaluateStance=TRUE){}
simulated function FriendlyStoppedMoving(){}
simulated function UpdateMeleeEnemiesInRange(){}
function bool Init(XGPlayer kPlayer, XGCharacter kNewChar, XGSquad kSquad, optional bool bDestroyOnBadLocation=FALSE, optional bool bSnapToGround=TRUE){}
function bool LoadInit(XGPlayer NewPlayer){}
simulated function ProcessDeathOnLoad(){}
simulated function NotifyPresentationLayersInitialized(){}
function SetMediKitCharges(int charges){}
simulated function int GetMediKitCharges(){}
simulated function bool SetStealthCharges(int charges){}
simulated function int GetStealthCharges(){}
simulated function int GetShredderRockets(){}
simulated function SetShredderRockets(int charges){}
simulated function int GetRockets(){}
simulated function SetRockets(int charges){}
simulated function SetGhostCharges(int charges){}
simulated function int GetGhostCharges(){}
simulated function SetSmokeGrenadeCharges(int charges){}
simulated function int GetSmokeGrenadeCharges(){}
simulated function SetBattleScannerCharges(int charges){}
simulated function int GetBattleScannerCharges(){}
simulated function int GetMimicBeaconCharges(){}
simulated function SetMimicBeaconCharges(int charges){}
simulated function int GetGasGrenades(){}
simulated function SetGasGrenades(int charges){}
simulated function int GetNeedleGrenades(){}
simulated function SetNeedleGrenades(int charges){}
simulated function int GetProximityMines(){}
simulated function SetProximityMines(int charges){}
simulated function int GetGhostGrenades(){}
simulated function SetGhostGrenades(int charges){}
simulated function int GetFlashBangs(){}
simulated function SetFlashBangs(int charges){}
simulated function SetArcThrowerCharges(int charges){}
simulated function int GetArcThrowerCharges(){}
simulated function int GetFragGrenades(){}
simulated function SetFragGrenades(int iGrenades){}
simulated function int GetAlienGrenades(){}
simulated function SetAlienGrenades(int iGrenades){}
simulated function int GetFlamethrowerCharges(){}
simulated function SetFlamethrowerCharges(int iCharges){}
simulated function CreateUnitView(){}
simulated function PlayerController GetOwningPlayerController(){}
simulated function ApplyLoadout(XGLoadoutInstances kLoadoutInstances, bool bLoadFromCheckpoint){}
function SetInitialNetPriorities(){}
simulated function bool SwapEquip(){}
simulated function bool CycleWeapons(){}
reliable server function ServerCycleWeapons(){}
simulated function EquipWeaponUI(XGWeapon NewWeapon){}
simulated function ConstantCombatSuppress(bool bSuppress, XGUnit kTarget){}
simulated function ConstantCombatSuppressArea(bool bSuppressArea){}
function bool IsCoverOccupied(XComCoverPoint kCover, optional bool bSkipSelf=TRUE){}
function float ScoreCoverInfo(XComCoverPoint kCover){}
function bool IsValidCoverType(XComCoverPoint kCover, optional bool bIgnoreFlight=FALSE){}
function float GetMaxPathDistance(){}
function bool IsFlightPoint(XComCoverPoint kCover){}
simulated function bool IsAboveFloorTile(Vector vLoc, optional int iMinTiles){}
function bool IsValidCover(XComCoverPoint kCover, int iMinDist, optional bool bTestDot=TRUE, optional bool bTestIM=FALSE, optional bool bIgnoreOutOfRangeCover=TRUE, optional bool bIgnoreFlight=FALSE){}
function int GetPathCostTo(Vector vDestination){}
delegate bool CoverValidator(Vector vCoverLoc){};
function bool DefaultCoverValidator(Vector vCoverLoc){}
function bool GetBestCoverLocation(out Vector vCoverLoc_out, optional int iMinDistance=128, optional delegate<CoverValidator> dCoverValid=DefaultCoverValidator, optional bool bCanIgnoreCover=TRUE, optional bool bIgnoreFlight=FALSE, optional out string strFail){}
function bool GetBestDestination(out Vector vCoverLoc_out, optional int iMinDistance=128, optional delegate<CoverValidator> dCoverValid=DefaultCoverValidator, optional bool bIgnoreOutOfRangeCover=TRUE, optional array<XComCoverPoint> predeterminedPoints, optional bool bCanIgnoreCover=TRUE, optional out string strFail, optional bool bGroundOnly=FALSE){}
function bool GetBestFlightDestination(out Vector vCoverLoc_out, array<XComCoverPoint> predeterminedPoints, optional int iMinDistance=128, optional delegate<CoverValidator> dCoverValid=DefaultCoverValidator){}
function bool GetBestCoverLocWithValidator(out Vector vCoverLoc_out, optional int iMinDistance=128, optional delegate<CoverValidator> dCoverValid=DefaultCoverValidator, optional bool bIgnoreOutOfRangeCover=TRUE, optional array<XComCoverPoint> predeterminedPoints, optional bool bCanIgnoreCover=TRUE, optional bool bIgnoreFlight=FALSE, optional out string strFail){}
simulated function bool DestinationIsReachable(Vector vLocation){}
simulated function bool CanTakeDamage(){}
function Vector GetRunAwayDestinationFromPoint(Vector vDangerPoint, float fMinDist){}
function ProcessSuppression(XGUnit kUnit){}
function Vector RunForCover(Vector vDangerLoc, optional delegate<CoverValidator> dCoverValid=DefaultCoverValidator, optional int iMinDist=128){}
simulated function bool IsCivilian(){}
simulated function bool IsCivilianChar(){}
simulated function bool IsLocalPlayerUnit(){}
simulated function XGUnit GetClosestEnemyInRange(){}
simulated function bool GetMoveDestTowardLocation(out Vector vOutDest, Vector vTarget, optional float fMaxDist=-1.0, optional bool bUseClosestCoverOnBadDestination=TRUE, optional bool bForceTileCacheUpdate=FALSE){}
function bool MoveToLocation(Vector vLoc, optional bool bUseComputePathForAIUnit=FALSE, optional bool bShowCrumbs=TRUE, optional bool bSpeak=TRUE, optional bool bSkipCamera=FALSE, optional bool bWalk=FALSE, optional bool bIgnoreCloseCombat=FALSE, optional bool bActionPoint=FALSE){}
function ExitLevel(){}
function bool IsEngaged(){}
function InitBehavior(){}
function DestroyBehavior(){}
function Uninit(){}
simulated event Destroyed(){}
function SpawnPawn(optional bool bSnapToGround=TRUE, optional bool bLoaded=FALSE){}
simulated function bool SnapToGround(optional float Distance=1024.0){}
function UpdateItemCharges(){}
simulated function bool IsAlien_CheckByCharType(){}
simulated function bool IsPsiCapableUnit(){}
simulated function AddRecoverFromCriticallyWoundedAction(){}
function AddCriticallyWoundedAction(optional bool bStunAlien, optional bool bLoading){}
function AddIdleAction(){}
function AddPathAction(optional int iCustomPathLength=0, optional bool bNoCloseCombat=FALSE){}
function AddFlightToggleAction(bool bFlightToggle, optional Vector vHitLoc);
function AddPsiReflectAction(XGUnit kTarget, int iDamage){}
function AddBecomePossessedAction(){}
function AddBecomeUnPossessedAction(){}
function AddZombieGetUpAction(XGUnit kSpawnedFrom){}
function AddChryssalidBiteAction(int iDamage, XGUnit kTargetedEnemy){}
function AddChryssalidBittenAction(){}
function AddChryssalidBirthAction(XGUnit kHatchedFrom){}
function AddChryssalidBirthVictimAction(){}
function AddMutonBeatDownAction(int iDamage, XGUnit kTargetedEnemy){}
function AddMutonBeatenDownAction(){}
function AddApplyAbilityEffectHiddenAction(){}
function AddRemoveAbilityEffectHiddenAction(){}
simulated function Vector GetVisibilityCoverOffsetAtCoverPoint(bool bLeft, XComCoverPoint kCoverPoint, int iDirIndex){}
simulated function bool CanSee(XGUnit kTarget, optional bool bIgnoreRange=FALSE, optional out UnitDirectionInfo DirectionInfo){}
simulated function bool CanSeeUnitAt(XGUnit kUnit, Vector vTestLocation, bool bIgnoreRange, optional bool bDoVisDebugging=FALSE, optional out Actor kHitActor){}
simulated function bool CanSeeActor(Actor kObject, optional float fHeight=0.0, optional Actor kSubObject=NONE){}
simulated function bool CanSeePoint(Vector vLoc, optional float ZOffset=0.0){}
simulated function int GetFloor(){}
function SetSightRadius(int iNewRadius){}
simulated function OnSightRadiusChange(){}
simulated function SetSightRingState(bool bEnabled){}
function ClearCustomAbility(){}
function NetProcessCustomAbilitiesWaitingToBeDestroyed(){}
function bool TakeOverwatchShot(XGUnit Target, optional bool bReactionFire, optional bool bCloseCombatShot){}
simulated function SetCanTakeCover(bool bCanTakeCover){}
simulated function bool CanAttackLocation(Vector vLoc, optional Vector vFromLoc){}
function SetAutoFiringRate(float fNewRate){}
simulated function bool HasEnemyAsFlanker(XGUnit kEnemy){}
simulated function int GetNumFlankers(){}
function bool IsInLowCover(){}
simulated event UpdateSuppression(){}
simulated event bool IsFlankedByOpposingTeam(){}
simulated function bool IsFlankedByTeam(XGPlayer kPlayer){}
simulated function bool CanIntimidate(){}
simulated function bool CanFly(){}
simulated function XComUpdatePhysics(){}
simulated function UpdateInteractClaim(){}
simulated function bool ShouldCrouchForCover(){}
simulated function bool PerformInteract(optional XComInteractiveLevelActor KActor=NONE){}
simulated function ECoverState GetInteractCoverState(){}
function SetIdleState(EIdleState eIdle){}
simulated function ShowMouseOverDisc(optional bool bShow=TRUE){}
simulated function SetDiscState(EDiscState eState){}
simulated function PlaceBoxMesh(){}
simulated function RefreshUnitDisc(){}
simulated function HideUnitDisc(){}
simulated function UpdateUnitDisc(){}
function bool IsRecentPlayedSpeech(ECharacterSpeech eCharSpeech){}
function UnitSpeakMultiKill(){}
function UnitSpeakKill(){}
function UnitSpeakMissed(){}
simulated function DelayStunSpeech(){}
simulated function DelayStunFailSpeech(){}
simulated function DelayPromotionSound(){}
simulated function DelayKillSting(){}
function DelaySpeechFlanked(){}
function DelaySpeechRocketScatter(){}
function DelaySpeechDoubleTap();
function DelaySpeechExplosion(){}
function DelayRocketFire(){}
function DelayAlienHiddenMovementSounds(){}
function bool AllowEnableSoldierSpeech(ECharacterSpeech eCharSpeech){}
function UnitSpeak(ECharacterSpeech eCharSpeech, optional bool bDeadUnitSound){}
function OnSeeEnemy(XGUnit kEnemy, EEnemyReveal eRevealType, optional bool bInterrupt){}
function SpawnOnSeenEnemyAction(XGUnit kEnemy){}
function OnSeeZombieSpawn(){}
function bool CanHear(Vector vSoundLoc, optional out float fDistSq){}
function bool CanSeeBuilding(XComBuildingVolume kBuildingVolume){}
simulated event SetVisible(bool bVisible){}
simulated function UpdateLookAt(){}
simulated function int GetNumSquadVisibleEnemies(XGUnit kUnit){}
simulated function array<XGUnit> GetVisibleEnemies(){}
simulated function array<XGUnit> GetVisibleFriends(){}
simulated function bool IsVisibleEnemy(XGUnit kEnemy){}
simulated function GetSuppressingEnemies(out array<XGUnit> arrToModify){}
simulated function bool IsSuppressedBy(XGUnit kUnit){}
simulated function GetEnemiesInRange(out array<XGUnit> arrToModify){}
simulated function bool IsInStrangleRange(XGUnit kEnemy, optional Vector vUnitLoc){}
simulated function MoveToClosestValidLocation(optional float fHeight=0.0){}
simulated function bool IsInEngagementRange(XGUnit kTarget){}
simulated function float SightLinesVisConstraint(float fWeaponRange){}
simulated function SightLinesRangeToTarget(XComUnitPawnNativeBase kTargetPawn, Vector vSrc, Vector vDst, bool bDrawDebugLines, optional out float fHeightBonusModifier, optional out float fGrenadeRange, optional out float fFixedRange, optional out float fModRange, optional out float fFinalModRange){}
function SetSquad(XGSquad kSquad){}
simulated function XGSquad GetSquad(){}
simulated function XGPlayer GetPlayer(){}
simulated function ETeam GetTeam(){}
simulated function bool IsEnemy(XGUnit kUnit){}
simulated function bool CheckUnitDelegate_IsMindMergeWhiplashDying(XGUnit kUnit){}
simulated function bool IsMindMergeWhiplashDying(){}
simulated function bool IsMoving(){}
simulated function bool IsMovingForRushCam(){}
function SetPodActivatedDuringMovement(){}
function bool PodActivatedDuringMovement(){}
simulated function bool IsAttacking(){}
simulated function bool IsHunkeredDown(){}
simulated function bool IsStrangled(){}
simulated function bool IsStrangling(){}
simulated function SetTakenTurnEndingAction(bool bResult){}
simulated function bool TakenTurnEndingAction(){}
simulated function bool CheckForEndTurn(){}
simulated function int GetOffense(){}
simulated function int GetDefense(){}
simulated function int GetUseAbilityCounter(){}
simulated function int GetMoves(){}
simulated function int GetPathLength(){}
simulated function int GetMoveModifierCost(optional int bFlying=0, optional int bIgnorePoison=0){}
simulated function int GetFlightFuelCost(){}
simulated function SetDashing(bool bDashing){}
simulated function TogglePathLength(){}
simulated function SetPathLength(int PathLength){}
function FreeTurn(){}
function ClearPathActions(optional bool bLeaveFront=TRUE, optional bool bAddEndMove=TRUE){}
function LoadoutChanged_UpdateModifiers(){}
function UpdateEquipment(){}
simulated function BeginTurn(optional bool bLoadedFromCheckpoint=FALSE){}
function EndTurn(){}
function ResetUseAbilities(){}
function ResetMoves(){}
simulated function int GetNumAbilities(optional bool bCheckAvailable){}
simulated function XGAbility GetAbility(int iAbility){}
simulated function XGAbility_Move GetMoveAbility(){}
simulated function GetAllAbilities(out array<XGAbility> arrAbilitiesOut){}
simulated function XGAbility_Targeted GetAbilitiesOfType(out array<XGAbility_Targeted> aAbilitiesOut, int iType, optional XGUnit kTarget){}
simulated function bool CanMove(){}
simulated function UpdateCiviliansInRange(){}
simulated function AddCiviliansInRangeByWeapon(XGWeapon kWeapon, float fCustomRange, out array<XGUnitNativeBase> arrEnemiesInRangeOfWeapon, out array<float> arrEnemiesInRangeOfWeapon_HeightBonusModifier, out array<float> arrEnemiesInRangeOfWeapon_DistanceToTargetSq, Vector vLocation){}
simulated function AddEnemiesInRangeByWeapon(XGWeapon kWeapon, float fCustomRange, out array<XGUnitNativeBase> arrEnemiesInRangeOfWeapon, array<XGUnitNativeBase> arrEnemiesInRangeOfWeapon_HeightBonusModifier, out array<float> arrEnemiesInRangeOfWeapon_DistanceToTargetSq, Vector vLocation, optional bool bSkipRoboticUnits=FALSE, optional bool bSkipNonRoboticUnits=FALSE){}
simulated function bool ShouldSkipTarget(XGUnit kTarget, bool bSkipRoboticUnits, bool bSkipNonRoboticUnits, optional bool bRequireLineOfSight, optional bool bAliveAndWellOnly, optional EAbility EAbility){}
simulated function AddTargetsInSight(ETargetUnitType kType, out array<XGUnitNativeBase> arrTargetsInSight, out array<float> arrTargetsInSight_DistanceToTargetSq, Vector vLocation, optional bool bSkipRoboticUnits, optional bool bSkipNonRoboticUnits, optional EAbility EAbility){}
simulated function AddTargetsInSquadSight(ETargetUnitType kType, out array<XGUnitNativeBase> arrTargetsInSquadSight, Vector vLocation, bool bRequireLineOfSight, optional bool bSkipRoboticUnits=FALSE, optional bool bSkipNonRoboticUnits=FALSE, optional EAbility EAbility=0){}
simulated function AddAllTargets(ETargetUnitType kType, out array<XGUnitNativeBase> arrEnemies, out array<float> arrEnemies_DistanceToTargetSq, Vector vLocation, optional bool bSkipRoboticUnits=FALSE, optional bool bSkipNonRoboticUnits=FALSE){}
simulated function DetermineEnemiesInRangeByWeapon(XGWeapon kWeapon, float fCustomRange, out array<XGUnitNativeBase> arrEnemiesInRangeOfWeapon, out array<float> arrEnemiesInRangeOfWeapon_HeightBonusModifier, out array<float> arrEnemiesInRangeOfWeapon_DistanceToTargetSq, Vector vLocation, optional bool bSkipRoboticUnits=FALSE, optional bool bSkipNonRoboticUnits=FALSE){}
simulated function DetermineEnemiesInSight(out array<XGUnitNativeBase> arrEnemiesInSight, out array<float> arrEnemiesInSight_DistanceToTargetSq, Vector vLocation, optional bool bSkipRoboticUnits, optional bool bSkipNonRoboticUnits, optional EAbility EAbility){}
simulated function DetermineEnemiesInSquadSight(out array<XGUnitNativeBase> arrEnemies, Vector vLocation, bool bRequireLineOfSight, optional bool bSkipRoboticUnits=FALSE, optional bool bSkipNonRoboticUnits=FALSE, optional EAbility EAbility=0){}
simulated function DetermineAllEnemies(out array<XGUnitNativeBase> arrEnemies, out array<float> arrEnemies_DistanceToTargetSq, Vector vLocation, optional bool bSkipRoboticUnits=FALSE, optional bool bSkipNonRoboticUnits=FALSE){}
simulated function DetermineDeadEnemies(out array<XGUnitNativeBase> arrDeadEnemies, out array<float> arrDistanceToDeadEnemies, Vector vLocation){}
simulated function DetermineDeadAllies(out array<XGUnitNativeBase> arrDeadAllies, out array<float> arrDistanceToDeadAllies, Vector vLocation){}
simulated function DetermineFriendsInRange(float fWithinRadius, bool bUseSquadSight, out array<XGUnitNativeBase> arrFriends, out array<float> arrDistanceToFriends, Vector vLocation, int bsCharacterFilter, optional bool bSkipRoboticUnits=FALSE, optional bool bSkipNonRoboticUnits=FALSE, optional bool bMedikitAbility=FALSE, optional bool bMindMergeAbility=FALSE){}
simulated function GetTargetsInRange(int iTargetType, int iRangeType, out array<XGUnitNativeBase> arrTargets, Vector vLocation, optional XGWeapon kWeapon, optional float fCustomRange=0.0, optional bool bNoLOSRequired, optional bool bSkipRoboticUnits=FALSE, optional bool bSkipNonRoboticUnits=FALSE, optional int eType=0){}
simulated function FilterStunTargets(out array<XGUnitNativeBase> arrTargets){}
function NetProcessAbilitiesWaitingToBeDestroyed(){}
function ForceDestroyAbilities(){}
simulated function RefreshAbilityList(){}
simulated function PerformAbility(EAbility eAbilityToPerform){}
reliable server function ServerPerformAbility(EAbility eAbilityToPerform){}
simulated function XComPerkManager PERKS(){}
simulated function AddPrimedWeaponAbilities(Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly=FALSE){}
simulated function XComPresentationLayer PRES(){}
simulated function int GetRemainingActions(){}
function GiveOneMoveAndOneAction(){}
function SetMoves(int iMoves){}
function SetFreeTurns(int iFreeTurns){}
function int GetFreeTurns(){}
function ResetTurnActions(){}
function ApplyAbilityCost(int iAbility, int iAbilityCost){}
function int GetUsedAbility(){}
function SetUsedAbility(int iAbility){}
function RemoveCoverBonuses(){}
simulated function int GetMaxMoves(){}
function SetUnitHP(int iNewHP){}
function SetShieldHP(int iNewHP){}
function EndMindMergeAbility(){}
function ApplyHPStatPenalties(){}
simulated event int GetUnitFlightFuel(){}
function SetUnitFlightFuel(int iNewFlightFuel){}
simulated function Heal(){}
simulated function bool HealBy(int PathSize){}
simulated function bool IsHurt(){}
simulated function bool GetRegenPheromonesTargets(out array<XGUnit> arrUnits){}
simulated function bool ApplyRegenPheromones(array<XGUnit> arrUnits){}
simulated function ApplyAdrenalineSurge(){}
simulated function ProcBubbleAdrenalineSurge(){}
simulated function int GetUnitMaxFlightFuel(){}
simulated function EItemType GetArmorType(){}
function int GetSHIVRank(){}
simulated function SetInventory(XGInventory kInventory){}
simulated function XGInventory GetInventory(){}
simulated function XComPathingPawn GetPathingPawn(){}
simulated function XGCharacter GetCharacter(){}
simulated function ESoldierClass GetSoldierClass(){}
simulated function string GetSoldierClassName(){}
function OnDeath(class<DamageType> DamageType, XGUnit kDamageDealer){}
function ClearAbilitiesOnDeath(bool bCriticalWound){}
function CheckForDamagedItems(){}
simulated function OnKill(XGUnit kVictim, optional int iZombifyChance=100){}
function FirstKillNarrative(){}
function bool HasPsiGift(){}
function bool IsPoisonous(class<DamageType> DamageType){}
function RollForPoison(XGUnit kDamageDealer){}
function ApplyCatchingBreath(){}
simulated function ShowCatchingBreathProcBubble(){}
function OnStrangleRelease(){}
function int OnTakeDamage(int iDamage, class<DamageType> inDamageType, XGUnit kDamageDealer, Vector HitLocation, Vector Momentum, optional Actor DamageCauser){}
function bool PassesWillTest(int iWillTest, int iMyMods, bool bThisIsPanic, optional XGUnit kVersus, optional int iEvenStatsChanceToFail=50){}
function bool PerformPanicTest(int iEventWill, optional XGUnit kAttacker, optional bool bUsingPsiPanicAbility=FALSE, optional int iMoraleEvent=-1){}
simulated function bool GetPointWithinMeleeRange(XGUnit kTarget, out Vector vLoc, optional bool bAvoidLowCover=FALSE, optional bool bAllowDiagonals=FALSE, optional bool bMatchTileOffset=FALSE){}
simulated function int GetChanceToIntimidate(){}
function Intimidate(XGUnit kTarget){}
function bool OnMoraleEvent(int iMoraleEvent, optional bool bDontPanic){}
simulated function HandleMoraleChanged(){}
function RecordKill(XGUnit kVictim, optional bool bDiedFromExplosiveDamage=FALSE){}
function RecordWounding(XGUnit kVictim){}
function RecordTookDamage(int iDamageAmount, XGUnit kDealer);
function RecordMove(float fPercentOfTotalTime, float fDistance);
function RecordShotStats(XGWeapon kWeapon, int iFired, int iHit);
function RecordMoraleLoss(int iLoss);
function RecordPanic();
simulated function DrawDebugLabel(Canvas kCanvas){}
simulated function DrawDebugModifiers(Canvas kCanvas, out Vector vScreenPos){}
function bool IsCoverExposed(XComCoverPoint kTestCover, optional XGUnit kEnemy=NONE, optional out float fDot, optional bool bDrawLines=FALSE, optional bool bIgnoreOutOfRangeCover=TRUE){}
simulated function XGInventoryItem GetAlienGrenade(){}
simulated function bool IsDormant(optional bool bFalseIfActivating){}
simulated function bool IsAliveHealthyAndActive(optional bool bFalseIfActivating){}
simulated function bool IsInVisibleAlienPod(){}
simulated function bool HasRangeAdvantageOver(XGUnitNativeBase kTarget, optional Vector vTargetLoc, optional Vector vMyLocation){}
simulated function DebugShowOrientation(){}
simulated function RenderReactionFireCylinders(){}
function DrawFlankingMarkers(XComCoverPoint Point, XGUnit Unit){}
function DrawFlankingCursor(XGUnit Enemy){}
function DisplayHeightDifferences(){}
simulated function bool ProcessVisibilityWithVisInfo(XGUnit kEnemy, out UnitDirectionInfo DirectionInfo, optional out Actor kHitActor, optional bool bIgnoreRange=FALSE){}
simulated function DebugVisibilityForSelf(optional bool kCanvas=FALSE, optional Vector vScreenPos){}
simulated function DebugCoverActors(XComTacticalCheatManager kCheatManager){}
simulated function DebugReaction(Canvas kCanvas, XComTacticalCheatManager kCheatManager){}
simulated function DebugTimeDilation(Canvas kCanvas, XComTacticalCheatManager kCheatManager){}
simulated function DebugCCState(){}
simulated function DebugVisibility(Canvas kCanvas, XComTacticalCheatManager kCheatManager){}
simulated function DebugAnims(int kCanvas, XComTacticalCheatManager kCheatManager){}
simulated function DebugTreads(){}
function int GetActionQueueCount(){}
function bool ActionQueueContains(name ClassName){}
function bool NextActionIs(name ClassName){}
function TerminateActions(){}
function AddAction(XGAction kAction, optional bool bIgnoreInterrupts=FALSE){}
function CalcHitRolls(int ShotIndex, XGAbility_Targeted ShotAbility, XGAction_Fire FireAction){}
function int AbsorbDamage(const int IncomingDamage, XGUnit kDamageCauser, XGWeapon kWeapon){}
function AddFireActionSequence(XGAction_Fire kFireAction){}
protected function ExecuteNextAction(){}
simulated function ExecuteClientProxyAction(XGAction kClientProxyAction){}
simulated function XGAction GetAction(){}
simulated function XGAction GetLastAction(){}
simulated function bool HasAction(int iActionID){}
simulated function bool IsActionOfClassInQueue(class<XGAction> kActionClass, optional out XGAction kAction){}
simulated function bool IsActiveUnit(){}
simulated function bool HasMovesLeft(){}
simulated function bool IsPerformingAction(){}
simulated function bool IsUnitBusy(){}
simulated function bool IsIdle(){}
simulated function bool IsNetworkIdle(bool bCountPathActionsAsIdle){}
simulated function OnMoveComplete(){}
simulated function Activate();
simulated function Deactivate();
simulated function StateIndependentOnActionCompleted(XGAction kAction){}
function OnActionCompleted(XGAction kAction){}
function OnChangedIndoorOutdoor(bool bWentInside){}
simulated function XComBuildingVolume GetBuilding(){}
simulated function XGCameraView GetCurrentView(){}
simulated function bool HasBombardAbility(){}
simulated function OnCyberdiscTransformComplete(){}
simulated function BeginPulseController();
simulated function EndPulseController();
simulated function BeginPanicEffects(){}
simulated function EndPanicEffects();
simulated function float GetHealthPct(){}
simulated function CheckForLowHealthEffects(){}
simulated function EndLowHealthEffects(){}
function TurnTowards(Vector vPointToLookAt, optional bool bIgnoreMovingCursor){}
function UnstealthAndFire(XGAbility_Targeted kShot){}
function UnstealthAndFireMP(XGAbility_Targeted kShot){}
function bool FireAtEnemy(){}
function DecrementPanicCounter();
function Stabilize(){}
function DecrementCriticalWoundCounter(){}
simulated function bool IsEnemySquadAttacking(){}
simulated function UnregisterAsViewer(){}
simulated function DelayedDisableTick(){}
simulated function DropWeapon(){}
simulated function ExplodePoison(){}
simulated function bool IsFlying(){}
simulated function bool InAscent(){}
simulated function SetIsFlying(bool bFlying){}
simulated function bool CanLand(optional Vector vLoc=Location){}
simulated function SetInAscent(bool bInAscent){}
simulated function bool IsAttemptingToHover(XCom3DCursor kCursor){}
simulated function bool CanSatisfyHoverRequirements(){}
function bool ProcessFlightMode(bool bEnable, float fTraceDistanceBelowUnit){}
simulated function XGUnit GetPossessionSlave(){}
simulated function XGUnit GetPossessedBy(){}
function BecomePossessed(XGAbility_Targeted kAbility, optional bool bDestroyAffectingMindMerge=true){}
function BecomeUnpossessed(){}
simulated function ClearAbilitiesOnMindControl(){}
function NeuralDampingControl(){}
function ApplyNeuralFeedback(XGAbility_Targeted kAbility){}
simulated function bool ActivatePerk(EPerkType Perk, optional XGUnit PrimaryTarget, optional array<XGUnit> AdditionalTargets, optional bool bReplicate=false, optional bool bSkipRMA=false){}
simulated function bool DeactivatePerk(EPerkType Perk, optional bool bReplicate=false){}
simulated function Equip(XGWeapon kWeapon){}
reliable server function ServerEquip(XGWeapon kWeapon){}
simulated function Reload(XGWeapon kWeapon){}
simulated function HunkerDown(){}
simulated function Overwatch(){}
function Panic(int iTurnsToPanic, optional bool bUsingPsiPanicAbility=false){}
function Unpanic(){}
function Flush(XGUnit kFlusher){}
function FlushEffect(){}
function XGVolume GetGameplayVolume(int iVolFind){}
function AddVolume(XGVolume kVolume){}
function RemoveVolume(XGVolume kVolume){}
function bool IsInGameplayVolume(XGVolume kVolume){}
function EnterSightBlockingVolume(XGVolume kVolume){}
function LeaveSightBlockingVolume(XGVolume kVolume){}
function XGVolume CreateTelekineticFieldVolume(){}
function XGVolume CreateRiftVolume(Vector LocationToSpawn){}
function TakeVolumeOverwatchShot(XGUnit kTarget, XGVolume kVolume){}
function TakeSuppressionOverwatchShot(XGUnit kTarget){}
function bool TakeReactionOverwatchShot(XGUnit kTarget, optional bool bCloseCombatShot=false){}
function OnTookVolumeOverwatchShot(XGUnit kTarget, XGVolume kVolume){}
function Burn(XGVolume kVolume){}
function ImplantEgg(XGPlayer kPlayer, XGAIChryssalidEgg.EEggDevStage eStage, optional bool bKilled=false, optional XGPod kPod=none){}
function SetElectropulsed(){}
function UpdateElectropulseTimer(){}
function bool IsVulnerableToElectropulse(){}
function SetPoisoned(bool bThinman){}
function OnEnterPoison(XGVolume kVolume){}
simulated function bool CurePoison(){}
function UpdatePoisonedTimer(){}
function TakePoisonDamage(){}
function TakeStrangleDamage(){}
function DoStealthAbility(){}
function UpdatePsiVolumes();
simulated function OnRiftEnd(){}
simulated function OnRiftBegin(Vector SpawnLocation){}
simulated function OnTelekineticFieldEnd(){}
simulated function OnTelekineticFieldBegin(Vector SpawnLocation){}
simulated function Uninit_BattleScanner(XGVolume kSpyVolume){}
simulated function OnBattleScannerEnd(XGVolume kVolume){}
simulated function Init_BattleScanner(Vector vLocation, ETeam eTeamVisibilityFlags){}
simulated function OnBattleScannerBegin(Vector vLoc){}
function PlayRandomSound(){}
simulated function bool GetVisibleTilesInPath(out array<int> arrTileList, Vector vDest, optional int iMaxTiles=5, optional bool bIgnoreInvisibleEnemies=false){}
simulated function bool IsPathVisible(Vector vDestination, out Vector vLastHidden, optional bool bCheckBothWays=false){}
simulated function bool IsPathVisibleToPlayer(XGPlayer kPlayer, out Vector vLastHidden){}
simulated function NotifyTarget_OnExplode(XComProjectile kProjectile, XGUnitNativeBase kFiredFromUnit, class<XComDamageType> kDamageType){}
simulated function OnLocalPlayerTeamTypeReceived(ETeam eLocalPlayerTeam){}
simulated function Vector AdjustSourceForMiss(Vector vStart, Vector vDirection, optional float fProjectileExtent=50.0){}
simulated function Vector AdjustTargetForMiss(XGUnit kTarget, optional float MissScalar=1.0, optional bool bUseSyncRand=false){}
function UpdateStatsFromGameCore(){}
function AddStatModifiers(int aStatModifiers[ECharacterStat], optional XGAbility_Targeted kAbility=none){}
function RemoveStatModifiers(int aStatModifiers[ECharacterStat]){}
function ApplyInventoryStatModifiers(){}
function ApplyStaticHeightBonusStatModifiers(){}
simulated function ClearAppliedAbility(int iAbilityType){}
simulated function TransferUpkeepOnAbilities(){}
simulated function ClearAffectingAbilityFromSelf(int iAbilityType){}
function ClearAffectingAbilities(optional bool bPsiOnly=false, optional XGAbility_Targeted kIgnore=none, optional bool bDestroyAffectingMindMerge=true){}
function OnTurnBeginHook(){}
function OnTurnEndHook(){}
function EndWeaponDisabled(){}
simulated function bool ActiveWeaponHasAmmoForShot(optional int iAbilityType=7, optional bool bReactionShot=false, optional bool bUsePrimaryWeapon=false){}
simulated function bool SecondaryWeaponHasAmmoForShot(){}
function UpdateAppliedAbilities(){}
simulated function XGAbility_Targeted GetAffectingAbility(int iAbility){}
simulated function XGUnit GetTargetOfAbility(int iAbility){}
simulated function bool GetTargetsOfAbility(out array<XGUnit> aTargets, int iAbility){}
simulated function XGUnit GetPerformerOfAbility(int iAbility){}
simulated function bool IsStatBuffed(ECharacterStat eStat, optional out int iBuffLevel){}
simulated function bool IsStatDebuffed(ECharacterStat eStat, optional out int iDebuffLevel){}
simulated function bool HasPenalties(){}
simulated function bool HasBonuses(){}
function OnLeaveTelekineticField(XGVolume kVolume){}
function OnEnterTelekineticField(XGVolume kVolume){}
function OnLeaveRift(XGVolume kVolume){}
function OnEnterRift(XGVolume kVolume){}
function TakeRiftDamage(XGUnit kRiftCaster, bool bInitialBlast){}
simulated function bool DormantAlienCheck(){}
simulated function bool SelfReactionAbilityCheck(){}
simulated function bool ReactionAbilityCheck(XGUnit kTarget){}
simulated function bool IsInCoverFacingRight(){}
simulated function bool IsInCoverFacingLeft(){}
simulated function bool IsTargetInReactionArea(XGUnit kTarget){}
simulated function float GetReactionPercent(){}
function ResetReaction(){}
function PsiDrain(XGUnit kTarget){}
simulated function bool ReactionWeaponCheck(){}
function bool SafeFromReactionFireMinDistToDest(){}
simulated function int GetReaction(){}
function ApplyReactionCost(int I, bool bPerformReactionCheck, bool bCoveringFireOnly, bool bReactiveTargetingOnly, optional XGUnit ReactiveTarget, optional XGUnit StrangleTarget){}
simulated function bool IsEnemyVisible(XGUnit kTarget){}
simulated function bool RapidReactionIsOk(XGUnit kTarget){}
simulated function bool CloseCombatSpecialist(XGUnit kTarget){}
simulated function bool HasSentinelModule(){}
simulated function ToggleReactionFireStatus(){}
reliable server function ServerToggleReactionFireStatus(){}
simulated function bool IsUsingFlush(){}
simulated event OnUpdatedVisibility(bool bVisibilityChanged){}
function XGAIPlayer GetAI(){}
simulated function Reanimate(optional bool bSwapTeams=false){}
function Vector GetConeCorner(bool bFirst, Vector vEndPoint, float fTheta){}
function bool IsPointInCone(Vector vPoint, Vector vEndPoint, float fTheta, optional bool b2DCheck){}
function bool IsOnSameFloor(XGUnit kAltUnit){}
simulated function RemoveRanges(){}
simulated function RemoveRangesOnSquad(XGSquad kSquad){}
simulated function DrawRanges(XCom3DCursor kCursor){}
simulated function DrawRangesOnSquad(XGSquad kSquad, XCom3DCursor kCursor){}
simulated function DrawRangesForMedikit(optional bool bDetach=true){}
simulated function DrawRangesForRevive(optional bool bDetach=true){}
simulated function DrawRangesForRepairSHIV(optional bool bDetach=true){}
simulated function DrawRangesForShotStun(optional XCom3DCursor kCursor=none, optional bool bDetach=true){}
simulated function DrawRangesForDroneHack(optional XCom3DCursor kCursor=none, optional bool bDetach=true){}
simulated function DrawRangesForCloseAndPersonal(optional bool bDetach=true){}
simulated function DrawRangesForKineticStrike(optional XCom3DCursor kCursor=none, optional bool bDetach=true){}
simulated function DrawRangesForFlamethrower(optional XCom3DCursor kCursor=none, optional bool bDetach=true){}
simulated function bool DoubleTapPerkStillValid(){}
simulated function MoveCursorToMe(){}
simulated function GenerateSafeCharacterNames(){}
simulated function int ReplicateActivatePerkData_ToString(optional int kRAPD=0){}
simulated function OnSetOnFire(){}
simulated function PlayTakeDamagePerkEffects(bool bOnDeath, XGUnit kDamageDealer){}
simulated event Tick(float fDeltaT){}
simulated function ConsolidateGreaterMindMergeAbility(XGAbility_Targeted kNewAbility, optional bool bCaster=false){}
simulated event PostBeginPlay(){}
simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, Vector vCameraPosition, Vector vCameraDir);

auto simulated state Inactive
{
    ignores EndState, ContinuedState, PausedState;

    simulated function Activate(){}
    simulated event BeginState(name nmPrev){}
}
simulated state UninitComplete
{
    ignores Activate, BeginState, EndState, ContinuedState, PausedState, Tick;
}
simulated state Active
{
    simulated function Activate(){}
    simulated function Deactivate(){}
    simulated event BeginState(name nmPrev){}
    simulated event EndState(name nmNext){}
    simulated function OnActionCompleted(XGAction kAction){}
    function AddFlightToggleAction(bool bFlightToggle, optional Vector vHitLoc){}
    function AddPathAction(optional int iCustomPathLength=0, optional bool bNoCloseCombat=false){}
}

simulated state Panicking
{
    simulated event BeginState(name nmPrev){}
    simulated event EndState(name nmPrev){}
    function Vector GetRandomTargetLocation(Vector vNearestEnemy){}
    function bool FireRandomly(Vector vNearestEnemy){}
    function ChoosePanicOption(){}
}

simulated state Panicked
{
    simulated event BeginState(name nmPrev){}
    simulated event EndState(name nmNext){}
    function DecrementPanicCounter(){}
    simulated function Activate(){}
    simulated function Deactivate(){}
    function AddAction(XGAction kAction, optional bool bIgnoreInterrupt=false){}
}

simulated state Dead
{
    ignores EndState, Activate, Deactivate, SetDiscState, ShowMouseOverDisc, AddAction, 
	    ExecuteNextAction;

    simulated function OnDeathUpdateHidden(){}
    simulated event BeginState(name nmPrev){}
    function int OnTakeDamage(int iDamage, class<DamageType> DamageType, XGUnit kDamageDealer, Vector HitLocation, Vector Momentum, optional Actor DamageCauser){}
}
defaultproperties
{
    m_bCanTakeCover=true
    m_sDefenseImage="<img src='img:///gfxMessageMgr.Defense'>"
    m_sOffenseImage="<img src='img:///gfxMessageMgr.Attack'>"
    m_sDamageImage="<img src='img:///gfxMessageMgr.Damage_red'>"
    m_sCriticalDamageImage="<img src='Icon_CRIT_HTML' vspace='-3' />"
    begin object name=UnitSelectComponent class=StaticMeshComponent
	    StaticMesh=none
        ReplacementPrimitive=none
        HiddenGame=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
	end object
    m_kDiscMesh=UnitSelectComponent
	Components.Add(UnitSelectComponent)

	begin object name=UnitHoverComponent class=StaticMeshComponent
        StaticMesh=none
        ReplacementPrimitive=none
        HiddenGame=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
	m_kBoxMesh=UnitHoverComponent
	Components.Add(UnitHoverComponent)
    m_kBoxMeshUnitSelectMaterial=none
    m_kBoxMeshEnemySelectMaterial=none

    begin object name=UnitFlyingComponent class=StaticMeshComponent
        StaticMesh=none
        ReplacementPrimitive=none
        HiddenGame=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    m_kFlyingRing=UnitFlyingComponent
	Components.Add(UnitFlyingComponent)

	begin object name=RangeIndicatorMeshComponent class=StaticMeshComponent
        StaticMesh=none
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
        Translation=(X=0.0,Y=0.0,Z=-44.30)
    end object
    m_kSightRing=RangeIndicatorMeshComponent
	Components.Add(RangeIndicatorMeshComponent)

    begin object name=SightRingIcon class=SpriteComponent
        Sprite=none
        ReplacementPrimitive=none
        HiddenGame=true
        AlwaysLoadOnServer=false
        Scale=0.250
    end object
    m_kSightRingIcon=SightRingIcon
	Components.Add(SightRingIcon)

	m_fAutoFiringRate=2.0
    m_iBindNextPathActionToClientProxyActionID=-1
    m_aPanicModifier[1]=-2

    begin object name=ForceFeedbackWaveform0 class=ForceFeedbackWaveform
        bIsLooping=true
    end object
    m_arrPanicFF=ForceFeedbackWaveform0

    begin object name=ForceFeedbackWaveform1 class=ForceFeedbackWaveform
        bIsLooping=true
    end object
    m_iZombieMoraleLoss=3
    m_iUnitLoadoutID=-1
    m_iLastIntimidateTurn=-1
    m_SavedAppearance=(iHead=-1,iGender=0,iRace=0,iHaircut=-1,iHairColor=0,iFacialHair=0,iBody=-1,iBodyMaterial=-1,iSkinColor=-1,iEyeColor=-1,iFlag=-1,iArmorSkin=-1,iVoice=-1,iLanguage=0,iAttitude=0,iArmorDeco=-1,iArmorTint=-1)
    m_bBuildAbilityDataDirty=true
    m_iPoisonTurn=-1
    begin object name=BEPSC class=ParticleSystemComponent
        ReplacementPrimitive=none
    end object
    m_BioElectricPSC=BEPSC
	Components.Add(BEPSC)
    begin object name=OnFirePSC class=ParticleSystemComponent
        ReplacementPrimitive=none
    end object    
	m_OnFirePSC=OnFirePSC
	Components.Add(OnFirePSC)
    m_bReplicateHidden=false

}
