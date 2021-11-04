class XGUnitNativeBase extends Actor
	native(Unit)
	config(GameCore)
	dependsOn(XGTacticalGameCoreData)
	dependsOn(XGInventoryNativeBase);
//complete stub

enum ECoverState
{
    eCS_None,
    eCS_LowLeft,
    eCS_LowRight,
    eCS_HighLeft,
    eCS_HighRight,
    eCS_HighFront,
    eCS_HighBack,
    eCS_LowFront,
    eCS_LowBack,
    eCS_MAX
};

enum EInteractionFacing
{
    eIF_None,
    eIF_Left,
    eIF_Right,
    eIF_Front,
    eIF_MAX
};

enum EIdleState
{
    eIdle_Normal,
    eIdle_HighAlert,
    eIdle_LookingAt,
    eIdle_Panicked,
    eIdle_Strangling,
    eIdle_Strangled,
    eIdle_MAX
};

enum EFavorDirection
{
    eFavor_None,
    eFavor_Left,
    eFavor_Right,
    eFavor_MAX
};

struct native AbilityCooldown
{
    var int iType;
    var int iCooldown;
};

struct native TDynamicSpawnedWeaponReplicationInfo
{
    var XGWeapon m_kDynamicSpawnWeapon;
    var XGInventoryNativeBase.ELocation m_eDynamicSpawnWeaponSlotLocation;
};

struct native FiringStateReplicationData
{
    var bool m_bHit;
    var bool m_bCritical;
    var int m_iDamage;
    var bool m_bKillShot;
    var bool m_bAttackerVisibleToEnemy;
    var bool m_bProjectileWillBeVisibleToEnemy;
    var bool m_bPlaySuccessfulKillAnimation;
    var Actor m_kTargetActor;
    var bool m_bTargetActorNone;
    var XGUnit m_kTargetedEnemy;
    var bool m_bTargetedEnemyNone;
    var bool m_bReflected;
    var bool m_bReplicated;
    var bool m_bCanApplyTracerBeamFX;
    var bool m_bShotIsBlocked;
    var Vector m_vHitLocation;
};

struct CheckpointRecord
{
    var int m_aCurrentStats[ECharacterStat];
    var int m_aInventoryStats[ECharacterStat];
    var int m_aHeightBonusStats[ECharacterStat];
    var XGCharacter m_kCharacter;
    var XGInventoryNativeBase m_kInventory;
    var XGSquadNativeBase m_kSquad;
    var bool m_bUseClaimedCoverLocation;
    var Vector m_vClaimedCoverLocation;
    var ECoverState m_eCoverState;
    var bool m_bCriticallyWounded;
    var bool m_bStunned;
    var XGAIBehavior m_kBehavior;
    var array<XGUnit> m_arrVisibleEnemies;
    var array<XGUnit> m_arrVisibleFriends;
    var array<XGUnit> m_arrEnemiesSeenBy;
    var array<XGUnit> m_arrFriendsSeenBy;
    var array<XGUnit> m_arrEnemiesEngagedBy;
    var array<UnitDirectionInfo> m_arrUnitDirectionInfos;
    var array<XGUnit> m_arrFriendsInRange;
    var array<XGUnit> m_arrCiviliansInRange;
    var array<XGUnit> m_arrVisibleCivilians;
    var array<XGUnit> m_arrEnemiesInCloseRange;
    var array<XGUnit> m_arrEnemiesRevealedWhileMoving;
    var array<XGUnit> m_arrFlankingUnits;
    var ETeam m_eTeam;
    var ETeam m_eTeamVisibilityFlags;
    var Vector RelativeLocation;
    var XGUnitNativeBase m_arrSuppressingEnemies[16];
    var int m_numSuppressingEnemies;
    var XGUnitNativeBase m_arrSuppressionTargets[16];
    var int m_numSuppressionTargets;
    var XGUnitNativeBase m_arrSuppressionExecutingEnemies[16];
    var int m_numSuppressionExecutingEnemies;
    var bool m_bDashing;
    var bool m_bSprinting;
    var bool m_bReactionFireStatus;
    var bool m_bOffTheBattlefield;
    var bool m_bIsInOverwatch;
    var bool m_bIsFlying;
    var bool m_bInAscent;
    var int m_iMovesActionsPerformed;
    var int m_iMoves;
    var int m_iUseAbilities;
    var int m_iFireActionsPerformed;
    var int m_iMediKitCharges;
    var int m_iShredderRockets;
    var int m_iRockets;
    var int m_iGhostCharges;
    var int m_iSmokeGrenades;
    var int m_iBattleScanners;
    var int m_iStealthCharges;
    var int m_iLastStealthTurn;
    var int m_iMimicBeaconCharges;
    var int m_iGasGrenades;
    var int m_iGhostGrenades;
    var int m_iFlashBangs;
    var int m_iNeedleGrenades;
    var int m_iProximityMines;
    var int m_iCurrentCoverValue;
    var int m_iBaseCoverValue;
    var int m_iNumAbilitiesApplied;
    var XGAbility_Targeted m_aAbilitiesApplied[64];
    var int m_iNumAbilitiesAffecting;
    var XGAbility_Targeted m_aAbilitiesAffecting[64];
    var int m_iShredderRocketCtr;
    var int m_arrBonuses[EPerkType];
    var int m_iNumOfBonuses;
    var bool m_bInDenseSmoke;
    var int m_arrPenalties[EPerkType];
    var int m_iNumOfPenalties;
    var int m_arrPassives[EPerkType];
    var int m_iTelekineticFieldCounter;
    var int m_iTelekineticField;
    var int m_iPoisonTurn;
    var int m_iRift;
    var bool m_bHasChryssalidEgg;
    var int m_iTracerBeamCtr;
    var bool m_bWeaponDisabled;
    var bool m_bInCombatDrugs;
    var bool m_bInSmokeBomb;
    var int m_eUsedAbility;
    var int m_iNumAbilitiesOnCooldown;
    var AbilityCooldown m_aAbilitiesOnCooldown[64];
    var int m_iArcThrowerCharges;
    var int m_iFragGrenades;
    var int m_iAlienGrenades;
    var int m_iFlamethrowerCharges;
    var byte m_iNumTimesUsedInTheZone;
    var bool m_bStabilized;
    var int m_iPanicCounter;
    var bool m_bVIP;
    var bool m_bRunAndGunActivated;
    var bool m_bLightningReflexesUsed;
    var bool m_bDoubleTapActivated;
    var int m_iFallenComrades;
    var bool m_bBattleScanner;
    var bool m_bRunAndGunUsedMove;
    var bool m_bHiding;
    var bool m_bMissedLastShot;
    var bool m_bNeuralDampingStun;
    var bool m_bFreeFireActionTaken;
    var bool m_bJetbootModuleActive;
    var XGUnitNativeBase m_kDistortionFieldProvider;
    var bool m_bExaltHacked;
    var bool m_bSentinelModuleDisabled;
    var int m_iElectropulseTurn;
    var bool m_bSquadLeader;
    var bool m_bOneForAllActive;
    var bool m_bWasJustStrangling;
    var bool m_bCelebrateAfterKill;
    var bool bSteppingOutOfCover;
    var ECoverState LastCoverState;
    var EExitCoverTypeToUse LastCoverTypeUsed;
    var Vector RestoreLocation;
    var Vector RestoreHeading;
    var bool bNeedsLowCoverStepOut;
    var XGAction_EnterCover StoredEnterCoverAction;
    var XGWeapon PriorMecWeapon;
};

struct native InventoryOperation
{
    var XGInventoryItem Item;
    var ELocation LocationTo;
    var ELocation LocationFrom;
    var bool bUpdateGameInventory;

};

var XGPlayerNativeBase m_kPlayerNativeBase;
var repnotify int m_aCurrentStats[ECharacterStat];
var repnotify int m_aInventoryStats[ECharacterStat];
var repnotify int m_aHeightBonusStats[ECharacterStat];
var repnotify XGCharacter m_kCharacter;
var repnotify XComUnitPawnNativeBase m_kPawn;
var XComPathingPawn m_kPathingPawn;
var XGInventoryNativeBase m_kInventory;
var XGActionQueue m_kActionQueue;
var XGNetExecActionQueue m_kNetExecActionQueue;
var bool m_bProcessingNetExecActionQueue;
var bool m_bUseClaimedCoverLocation;
var bool m_bInPodReveal;
var bool m_bCriticallyWounded;
var bool m_bStunned;
var repnotify bool m_bDashing;
var bool m_bSprinting;
var bool m_bHasMoved;
var repnotify bool m_bReactionFireStatus;
var bool m_bCachedIsInCover;
var bool m_bInDenseSmoke;
var repnotify bool m_bWeaponDisabled;
var bool m_bInCombatDrugs;
var bool m_bInSmokeBomb;
var bool m_bStabilized;
var bool m_bRunAndGunUsedMove;
var bool m_bWasJustStrangling;
var bool m_bStrangleStarted;
var bool m_bSquadLeader;
var bool m_bAttacksCivilians;
var bool m_bOffTheBattlefield;
var bool m_bForceVisible;
var bool m_bIsFlying;
var bool m_bInAscent;
var bool m_bBattleScanner;
var bool m_bDebugUnitVis;
var bool m_bHasChryssalidEgg;
var bool m_bForceHidden;
var bool m_bHiding;
var bool m_bAbilitiesInitiallyReplicated;
var bool m_bBuildAbilitiesTriggeredFromVisibilityChange;
var bool m_bCheckingAbilitiesForInitialReplication;
var bool m_bBuildAbilityDataDirty;
var bool m_bMissedLastShot;
var bool m_bNeuralDampingStun;
var bool m_bFreeFireActionTaken;
var bool m_bCloseAndPersonalTaken;
var bool m_bJetbootModuleActive;
var bool m_bExaltHacked;
var bool m_bSentinelModuleDisabled;
var bool m_bOneForAllActive;
var bool m_bInCover;
var bool m_bVIP;
var bool m_bRunAndGunActivated;
var bool m_bLightningReflexesUsed;
var bool m_bDoubleTapActivated;
var bool m_bIsInOverwatch;
var bool m_bInCinematicMode;
var bool m_bInCinematicKineticStrikeDeath;
var bool m_bCelebrateAfterKill;
var bool bSteppingOutOfCover;
var bool bNeedsLowCoverStepOut;
var bool bChangedWeapon;
var protectedwrite bool m_bFlankDataWatchVariable;
var repnotify bool m_bEnableBioElectricParticles;
var XGAction m_kCurrAction;
var XGSquadNativeBase m_kSquad;
var EIdleState m_eIdle;
var ECoverState m_eCoverState;
var EFavorDirection m_eFavorDir;
var byte m_iNumTimesUsedInTheZone;
var repnotify byte m_iBuildAbilityNotifier;
var ECoverState LastCoverState;
var EExitCoverTypeToUse LastCoverTypeUsed;
var ELocation m_eEquipSlot;
var ELocation m_eReEquipSlot;
var Vector m_vClaimedCoverLocation;
var int m_FavorCoverIndex;
var XGAIBehavior m_kBehavior;
var int m_iLastTurnFireDamaged;
var transient array<Actor> m_aCoverActors;
var int m_iCurrentCoverValue;
var int m_iBaseCoverValue;
var int m_arrBonuses[EPerkType];
var int m_iNumOfBonuses;
var int m_arrPenalties[EPerkType];
var int m_iNumOfPenalties;
var int m_arrPassives[EPerkType];
var int m_iTelekineticFieldCounter;
var int m_iTelekineticField;
var int m_iPoisonTurn;
var int m_iRift;
var int m_iTracerBeamCtr;
var array<XGUnit> m_akPossessedMindMergee;
var int m_eUsedAbility;
var AbilityCooldown m_aAbilitiesOnCooldown[64];
var int m_iArcThrowerCharges;
var int m_iFragGrenades;
var int m_iAlienGrenades;
var int m_iFlamethrowerCharges;
var int m_iPanicCounter;
var int m_iFallenComrades;
var int m_iElectropulseTurn;
var repnotify TDynamicSpawnedWeaponReplicationInfo m_kDynamicSpawnedSmokeGrenade;
var repnotify TDynamicSpawnedWeaponReplicationInfo m_kDynamicSpawnedBattleScanner;
var array<XComInteractPoint> m_arrInteractPoints;
var repnotify int m_iNumAbilities;
var repnotify XGAbility m_aAbilities[64];
var XGAbility_Targeted m_kCustomAbility;
var int m_iNumAbilitiesApplied;
var XGAbility_Targeted m_aAbilitiesApplied[64];
var int m_iNumAbilitiesOnCooldown;
var array<XGAbility> m_aNetAbilitiesWaitingToBeDestroyed;
var array<XGAbility> m_aNetCustomAbilitiesWaitingToBeDestroyed;
var int m_iNumAbilitiesAffecting;
var XGAbility_Targeted m_aAbilitiesAffecting[64];
var int m_iMovesActionsPerformed;
var repnotify int m_iMoves;
var repnotify int m_iUseAbilities;
var int m_iFireActionsPerformed;
var int m_iMediKitCharges;
var int m_iShredderRockets;
var int m_iRockets;
var int m_iGhostCharges;
var int m_iSmokeGrenades;
var int m_iBattleScanners;
var int m_iStealthCharges;
var int m_iLastStealthTurn;
var int m_iMimicBeaconCharges;
var int m_iGasGrenades;
var int m_iGhostGrenades;
var int m_iFlashBangs;
var int m_iNeedleGrenades;
var int m_iProximityMines;
var int m_iShredderRocketCtr;
var XGUnit m_kConstantCombatUnitTargettingMe;
var XGUnit m_kRapidReactionUnit;
var Vector m_vRapidReactionLoc;
var config int AdditionalProximityMines;
var config int AdditionalGrenades;
var config int AdditionalRestorativeMistShots;
var config float BioelectricSkinRange;
var XGUnitNativeBase m_kDistortionFieldProvider;
var int CurrentCoverPointFlags;
var int CurrentCoverDirectionIndex;
var float FlankingAngle;
var float ClaimDistance;
var float CornerClaimDistance;
var CachedVisibilityQueryData VisibilityQueryCache;
var XComIdleAnimationStateMachine IdleStateMachine;
var repnotify XGUnitNativeBase m_arrSuppressingEnemies[16];
var repnotify int m_numSuppressingEnemies;
var repnotify XGUnitNativeBase m_arrSuppressionTargets[16];
var repnotify int m_numSuppressionTargets;
var repnotify XGUnitNativeBase m_arrSuppressionExecutingEnemies[16];
var repnotify int m_numSuppressionExecutingEnemies;
var UnitDirectionInfo PositionDirectionInfo;
var Vector RestoreLocation;
var Vector RestoreHeading;
var XGAction_EnterCover StoredEnterCoverAction;
var XGWeapon PriorMecWeapon;
var array<InventoryOperation> InventoryOperations;
var FiringStateReplicationData m_arrFiringStateRepDatas[EXGAbilityNumTargets];
var int NumShots;
var array<XGUnit> m_arrVisibleEnemies;
var array<XGUnit> m_arrVisibleFriends;
var array<XGUnit> m_arrEnemiesSeenBy;
var array<XGUnit> m_arrFriendsSeenBy;
var array<XGUnit> m_arrEnemiesEngagedBy;
var array<UnitDirectionInfo> m_arrUnitDirectionInfos;
var array<XGUnit> m_arrFriendsInRange;
var array<XGUnit> m_arrCiviliansInRange;
var array<XGUnit> m_arrVisibleCivilians;
var array<XGUnit> m_arrEnemiesInCloseRange;
var array<XGUnit> m_arrEnemiesRevealedWhileMoving;
var array<XGUnit> m_arrFlankingUnits;
var repnotify const XGUnitNativeBase m_arrVisibleEnemiesReplicated[16];
var const int m_iNumVisibleEnemiesReplicated;
var repnotify const XGUnitNativeBase m_arrVisibleFriendsReplicated[16];
var const int m_iNumVisibleFriendsReplicated;
var repnotify const XGUnitNativeBase m_arrEnemiesSeenByReplicated[16];
var const int m_iNumEnemiesSeenByReplicated;
var repnotify const XGUnitNativeBase m_arrFriendsSeenByReplicated[16];
var const int m_iNumFriendsSeenByReplicated;
var repnotify const XGUnitNativeBase m_arrEnemiesEngagedByReplicated[16];
var const int m_iNumEnemiesEngagedByReplicated;
var repnotify const UnitDirectionInfo m_arrUnitDirectionInfosReplicated[16];
var const int m_iNumUnitDirectionInfosReplicated;
var repnotify const XGUnitNativeBase m_arrFriendsInRangeReplicated[16];
var const int m_iNumFriendsInRangeReplicated;
var repnotify const XGUnitNativeBase m_arrCiviliansInRangeReplicated[16];
var const int m_iNumCiviliansInRangeReplicated;
var repnotify const XGUnitNativeBase m_arrVisibleCiviliansReplicated[32];
var const int m_iNumVisibleCiviliansReplicated;
var repnotify const XGUnitNativeBase m_arrEnemiesInCloseRangeReplicated[16];
var const int m_iNumEnemiesInCloseRangeReplicated;
var repnotify const XGUnitNativeBase m_arrEnemiesRevealedWhileMovingReplicated[16];
var const int m_iNumEnemiesRevealedWhileMovingReplicated;
var repnotify const XGUnitNativeBase m_arrFlankingUnitsReplicated[16];
var const int m_iNumFlankingUnitsReplicated;
var string BioElectricParticleName;
var export editinline ParticleSystemComponent m_BioElectricPSC;
var export editinline ParticleSystemComponent m_OnFirePSC;

function LogAbilitiesSaveLoad(string strPrefix){}
simulated function InCinematicMode(bool bInCinematicMode){}
simulated function bool IsInCinematicMode(){}
native simulated function UpdateCoverClaim(optional ECoverState lastCoverStateHint);
native simulated function UnClaimCover();
native simulated function SetCover(bool bInCover, optional ECoverState lastCoverStateHint);
native simulated function ComputeCoverState(optional ECoverState lastCoverStateHint);
native simulated function ECoverState ConvertToLowCover(ECoverState oldCoverState);
native simulated function ECoverState ConvertToHighCover(ECoverState oldCoverState);
native simulated function float DirectionDotProduct(Vector vTargetDir);
native simulated function bool HasReaperRoundsForWeapon(int iWeapon);
native simulated function bool HasCouncilFightBonus();
native simulated function GetAbilitiesApplied(out array<XGAbility_Targeted> arrAbilities_Out);
native simulated function GetAbilitiesAffecting(out array<XGAbility_Targeted> arrAbilities_Out);
simulated function bool CleanUpAbilitiesApplied(optional XGAbility_Targeted kAbilityToRemove){}
native simulated function bool NativeCleanUpAbilitiesApplied(XGAbility_Targeted kAbilityToRemove);
simulated function bool CleanUpAbilitiesAffecting(optional XGAbility_Targeted kAbilityToRemove){}
native simulated function bool NativeCleanUpAbilitiesAffecting(XGAbility_Targeted kAbilityToRemove);
simulated function AddAbilityApplied(XGAbility_Targeted kAbility){}
simulated function bool RemoveAbilityApplied(XGAbility_Targeted kAbility){}
simulated function AddAbilityAffecting(XGAbility_Targeted kAbility){}
simulated function bool RemoveAbilityAffecting(XGAbility_Targeted kAbility){}
native simulated function XGAbility_Targeted FindAbilityAffecting(int iType);
native simulated function bool HasDistortionFieldBonus();
native simulated function bool HasSquadLeaderOTSBonus();
native function int AddSuppressor(XGUnitNativeBase kWatcher);
native function RemoveSuppressor(XGUnitNativeBase kWatcher);
native function ClearSuppressingEnemies();
native simulated function int FindSuppressor(XGUnitNativeBase kWatcher);
native simulated function bool IsBeingSuppressed();
native simulated function int GetNumberOfSuppressors();
simulated function XGUnit GetSuppressor(int Idx){}
native function int AddSuppressionTarget(XGUnitNativeBase kTarget);
native function RemoveSuppressionTarget(XGUnitNativeBase kTarget);
native function ClearSuppressionTargets();
native simulated function int GetNumberOfSuppressionTargets();
simulated function XGUnit GetSuppressionTarget(int Idx){}
native simulated function bool IsInOverwatch();
simulated event UpdateSuppression();
function bool TakeOverwatchShot(XGUnit Target, optional bool bReactionFire, optional bool bCloseCombatShot){}
native function int AddToSuppressionExecuting(XGUnitNativeBase kWatcher);
native function RemoveFromSuppressionExecuting(XGUnitNativeBase kWatcher);
native simulated function bool IsSuppressionExecuting();
native simulated function XGUnitNativeBase GetFirstSuppressionExecuting();
native simulated function ClearSuppressionExecuting();
native simulated function int GetNumberOfSuppressionExecutingEnemies();
native simulated function bool IsInside();
simulated function XGInventory GetInventory();
simulated function XGAction GetAction();
simulated function XGPlayer GetPlayer();
simulated function XGCharacter GetCharacter();
simulated function bool IsEnemy(XGUnit kUnit);
simulated function bool IsMoving();
function OnChangedIndoorOutdoor(bool bWentInside);
native simulated function bool IsPointWithinFiringRange(out float fHeightBonusModifier, out float fDistSq, XGUnitNativeBase kTarget, Vector vTargetPoint, Vector vShooterLocation, optional XGWeapon kWeapon, optional float fOverrideRange){}
simulated function SetDiscState(EDiscState eState);
function int OnTakeDamage(int iDamage, class<DamageType> DamageType, XGUnit kDamageDealer, Vector HitLocation, Vector Momentum, optional Actor DamageCauser);
simulated function HideCoverIcon();
function UnitSpeak(XGGameData.ECharacterSpeech eCharSpeech, optional bool bDeadUnitSound){}
event Speak(XGGameData.ECharacterSpeech SpeechEvent){}
native simulated function bool DoFlyingUnitToGroundVoxelTrace(out Vector OutLocation);
native simulated function SetVisibleToTeams(byte eVisibleToTeamsFlags);
native simulated function AddFlagToVisibleToTeams(byte eAddTeamFlag);
native simulated function ClearFlagFromVisibleToTeams(byte eClearTeamFlag);
native simulated function SetEnableBioElectricParticles(bool bEnableParticles);
native simulated function SetBioElectricParticlesVisible();
native simulated function int GetSightRadius();
native simulated function PawnPerformPhysics(float DeltaTime);
native final simulated function Vector GetGameplayLocationForCoverQueries();
native final simulated function UpdateGameplayLocationForCoverQueries(bool bInCover);
native final simulated function SetCoverDirectionIndex(int Index);
native final simulated function int GetCoverDirectionIndex();
native final simulated function bool IsFlankingCoverPoint(XComCoverPoint kCover);
native final simulated function bool IsInCover();
native final simulated function bool UpdateCoverFlags(optional out byte flagsChanged);
native final simulated function bool IsFlankedByLoc(Vector Loc);
native final simulated function float GetBestFlankingDot(Vector Loc);
native final simulated function Vector GetCoverDirection(optional int Index=-1);
native final simulated function Vector GetCoverLocation(optional int Index=-1);
native final simulated function Scout.ECoverType GetCoverType(optional int Index=-1);
native final simulated function bool GetCoverPeekRight();
native final simulated function bool GetCoverPeekLeft();
native final simulated function bool ClaimCoverNow();
native final simulated function UnClaimCoverNow();
native final simulated function bool GetClosestCoverPoint(float SampleRadius, out XComCoverPoint Point, optional out float Distance, optional bool bTypeStanding);
native final simulated function XComCoverPoint GetCoverPoint();
native final simulated function FindCoverActors(const out XComCoverPoint CoverPoint);
native final simulated function bool CanFlank();
native final simulated function bool CanBeFlanked();
native static simulated function bool DoesFlankCover(Vector PointA, XComCoverPoint kCover);
native static simulated function bool DoesFlank(Vector PointA, Vector PointB, Vector DirOfPointB);
simulated event bool IsFlankedByOpposingTeam();
native simulated function XGUnitNativeBase HasRangeAdvantage(XGUnitNativeBase kTarget, Vector vTargetLoc, Vector vMyLocation);
simulated function bool IsActiveUnit();
simulated event float ProcessRelativeHeightWeaponRangeBonus(XComUnitPawnNativeBase kTargetPawn, float fTargetZ, float fSelfZ, XGWeapon kWeapon){}
native simulated function float ApplyRangeModifiers(XComUnitPawnNativeBase kTargetPawn, float defaultWeaponRange, out float fHeightBonusModifier, XGWeapon kWeapon, float fTargetPawnLocationZ, float fSelfLocationZ);
simulated function ECoverState PredictCoverState(Vector vFromLoc, XComCoverPoint hCoverPoint, optional out Vector vOutCoverDirection){}
native simulated function bool CurrentMoveSupportsPodActivation();
native simulated function bool IsWaitingForPodRevealToMove();
native simulated function bool IsReactionFiring();
reliable server function SetBattleScanner(bool bIsBattleScanner){}
simulated function bool IsBattleScanner(){}
simulated event ReplicatedEvent(name VarName){}
simulated event PreBeginPlay(){}
function bool Init(XGPlayer kPlayer, XGCharacter kNewChar, XGSquad kSquad, optional bool bDestroyOnBadLocation, optional bool bSnapToGround=true){}
function bool LoadInit(XGPlayer kPlayer){}
native simulated function bool IsVisible();
simulated function SortVisibleEnemies(){}
function AddVisibleEnemy(XGUnit kEnemy){}
native final function AddVisibleEnemyReplicated(XGUnitNativeBase kEnemy);
native final function SetVisibleEnemiesReplicated(const out array<XGUnitNativeBase> arrVisibleEnemies);
native final function RemoveVisibleEnemy(XGUnitNativeBase kEnemy);
native final function RemoveVisibleEnemyReplicated(XGUnitNativeBase kEnemy);
simulated function bool HasVisibleFlankers(){}
simulated event CallDeactivatePerk(EPerkType Perk){}
function ClearVisibleEnemies(){}
native final function ClearVisibleEnemiesReplicated();
native final function RemoveVisibleFriend(XGUnitNativeBase kFriend);
native final function RemoveVisibleFriendReplicated(XGUnitNativeBase kFriend);
function ClearVisibleFriends(){}
native final function ClearVisibleFriendsReplicated();
function AddEnemySeenBy(XGUnit kEnemy){}
native final function AddEnemySeenByReplicated(XGUnitNativeBase kEnemy);
function ClearEnemiesSeenBy(){}
native final function ClearEnemiesSeenByReplicated();
function RemoveUnitFromEnemiesSeenBy(XGUnit kUnit){}
native final function RemoveUnitFromEnemiesSeenByReplicated(XGUnitNativeBase kUnit);
simulated function array<XGUnit> GetFriendsSeenBy(){}
function AddVisibleFriend(XGUnit kFriend){}
native final function AddVisibleFriendReplicated(XGUnitNativeBase kFriend);
function AddFriendSeenBy(XGUnit kFriend){}
native final function AddFriendSeenByReplicated(XGUnitNativeBase kFriend);
function ClearFriendsSeenBy(){}
native final function ClearFriendsSeenByReplicated();
function RemoveUnitFromFriendsSeenBy(XGUnit kUnit){}
native final function RemoveUnitFromFriendsSeenByReplicated(XGUnitNativeBase kUnit);
function AddEnemyEngagedBy(XGUnit kEnemy){}
native final function AddEnemyEngagedByReplicated(XGUnitNativeBase kEnemy);
function RemoveEnemyEngagedBy(XGUnit kEnemy){}
native final function RemoveEnemyEngagedByReplicated(XGUnitNativeBase kEnemy);
function ClearEnemiesEngagedBy(){}
native final function ClearEnemiesEngagedByReplicated();
simulated function bool IsPointInMeleeRange(Vector vTargetLocation, optional Vector vMyLocation=Location, optional bool bAllowDiagonals){}
simulated function bool IsInMeleeRange(XGUnit kEnemy, optional Vector vUnitLoc=Location, optional bool bAllowDiagonals){}
simulated function bool HasHighCoverBetweenPoints(Vector vLocA, Vector vLocB, optional bool bAvoidLowCover){}
simulated function bool HasHighCoverAtHelper(Vector vLocA, Vector vLocB, optional bool bAvoidLowCover){}
simulated function bool IsValidMeleePositionHelper(XGUnit kTarget, Vector vLoc, optional bool bDebugLog, optional bool bAvoidLowCover, optional bool bAllowDiagonals){}
function bool HasAttackableEnemies(optional out XGUnitNativeBase kUnit_Out){}
function bool HasAttackableCivilians(optional out XGUnitNativeBase kUnit_Out){}
native final function AddEngagingEnemyReplicated(UnitDirectionInfo kEnemyVisInfo);
native final function RemoveEngagingEnemy(XGUnitNativeBase kEnemy);
native final function RemoveEngagingEnemyReplicated(const out UnitDirectionInfo kEnemyVisInfo);
function ClearEngagingEnemies(){}
native final function ClearEngagingEnemiesReplicated();
function SetFriendsInRange(const out array<XGUnit> arrNewFriendsInRange){}
native final function SetFriendsInRangeReplicated(const out array<XGUnitNativeBase> arrNewFriendsInRange);
function AddFriendInRange(XGUnit kFriend){}
native final function AddFriendInRangeReplicated(XGUnitNativeBase kFriend);
function ClearFriendsInRange(){}
native final function ClearFriendsInRangeReplicated();
function AddCivilianInRange(XGUnit kCivilian){}
native final function AddCivilianInRangeReplicated(XGUnitNativeBase kCivilian);
function ClearCiviliansInRange(){}
native final function ClearCiviliansInRangeReplicated();
function AddVisibleCivilian(XGUnit kCivilian){}
native final function AddVisibleCivilianReplicated(XGUnitNativeBase kCivilian);
function RemoveVisibleCivilian(XGUnit kCivilian){}
native final function RemoveVisibleCivilianReplicated(XGUnitNativeBase kCivilian);
function ClearVisibleCivilians(){}
function bool IsVisibleCivilian(XGUnit kCivilian){}
native final function ClearVisibleCiviliansReplicated();
function AddEnemyToCloseRange(XGUnit kEnemyUnit){}
native final function AddEnemyToCloseRangeReplicated(XGUnitNativeBase kEnemyUnit);
function RemoveEnemyFromCloseRange(XGUnit kEnemyUnit){}
native final function RemoveEnemyFromCloseRangeReplicated(XGUnitNativeBase kEnemyUnit);
native final function ClearEnemiesInCloseRangeReplicated();
function AddEnemyRevealedWhileMoving(XGUnit kEnemy){}
native final function AddEnemyRevealedWhileMovingReplicated(XGUnitNativeBase kEnemy);
function RemoveEnemyRevealedWhileMoving(XGUnit kEnemy){}
native final function RemoveEnemyRevealedWhileMovingReplicated(XGUnitNativeBase kEnemy);
function ClearEnemiesRevealedWhileMoving(){}
native final function ClearEnemiesRevealedWhileMovingReplicated();
native final function bool AddFlanker(XGUnit kFlanker);
native final function AddFlankerReplicated(XGUnitNativeBase kFlanker);
native final function bool RemoveFlanker(XGUnit kFlanker);
native final function RemoveFlankerReplicated(XGUnitNativeBase kFlanker);
native final function ClearFlankers();
native final function FlankCheck();
native final function NotifyVisibleEnemiesFlankDataChanged();
native final function RemoveEffect(int iEffect);
simulated event EndPsiEffect(XGAbility_Targeted kPsiAbility){}
native final function Unhide();
native simulated function ClearAllVisibilityArrays();
// Export UXGUnitNativeBase::execSetUnitCoverState(FFrame&, void* const)
native final simulated function SetUnitCoverState(ECoverState newCover, optional float BlendTime=-1.0);

// Export UXGUnitNativeBase::execIsMine(FFrame&, void* const)
native simulated function bool IsMine();

simulated function XGGameData.EPawnType GetPawnType()
{
    return m_kCharacter.m_eType;
}

// Export UXGUnitNativeBase::execIsCriticallyWounded(FFrame&, void* const)
native simulated function bool IsCriticallyWounded();

// Export UXGUnitNativeBase::execIsEnemyInRange(FFrame&, void* const)
native simulated function bool IsEnemyInRange(XGUnitNativeBase kTarget);

// Export UXGUnitNativeBase::execIsCivilianInRange(FFrame&, void* const)
native simulated function bool IsCivilianInRange(XGUnitNativeBase kTarget);

// Export UXGUnitNativeBase::execGetNextMeleeOffset(FFrame&, void* const)
native simulated function bool GetNextMeleeOffset(out int iX, out int iY, bool bForward);

// Export UXGUnitNativeBase::execGetClosestVisibleEnemy(FFrame&, void* const)
native simulated function XGUnit GetClosestVisibleEnemy();

// Export UXGUnitNativeBase::execIsFlankedBy(FFrame&, void* const)
native simulated function bool IsFlankedBy(XGUnitNativeBase kEnemy);

// Export UXGUnitNativeBase::execIsFlankedBy_EnemyAtLocation(FFrame&, void* const)
native simulated function bool IsFlankedBy_EnemyAtLocation(XGUnitNativeBase kEnemy, const out Vector vEnemyLocation, optional bool bDebugLog);

// Export UXGUnitNativeBase::execIsUnderEffect(FFrame&, void* const)
native simulated function bool IsUnderEffect(int iEffect);

// Export UXGUnitNativeBase::execIsHiding(FFrame&, void* const)
native simulated function bool IsHiding(optional XGUnitNativeBase kUnit);

function SetWill(int iNewWill)
{
}

// Export UXGUnitNativeBase::execGetWill(FFrame&, void* const)
native simulated function int GetWill();

// Export UXGUnitNativeBase::execGetLocation(FFrame&, void* const)
native simulated event Vector GetLocation();
simulated event Vector GetLocation_AdjustedByPeekTestHeight(){}
simulated function Vector GetFootLocation(){}
simulated function float GetWorldZ(optional out float fFootZ){}
simulated event int GetFallenComradesWillPenalty(){}
simulated event int GetBattleFatigueWillPenalty(){}
simulated event array<XGUnit> GetEnemiesSeenBy(){}
simulated event bool isHuman(){}
simulated function bool IsShiv(){}
simulated function bool IsLoadOutShiv(XGGameData.EPawnType PawnType){}
simulated event bool IsAlien(){}
simulated function bool IsExalt(){}
// Export UXGUnitNativeBase::execIsAliveAndWell(FFrame&, void* const)
native simulated event bool IsAliveAndWell(optional bool bIgnoreStrangle);

// Export UXGUnitNativeBase::execIsAliveAndVisible(FFrame&, void* const)
native simulated event bool IsAliveAndVisible();

// Export UXGUnitNativeBase::execIsAlive(FFrame&, void* const)
native simulated event bool IsAlive();

// Export UXGUnitNativeBase::execIsAlert(FFrame&, void* const)
native final function bool IsAlert();

simulated event string SafeGetCharacterName()
{
}

simulated event string SafeGetCharacterFullName()
{
}

simulated event string SafeGetCharacterFirstName()
{
}

simulated event string SafeGetCharacterLastName()
{
}

simulated event string SafeGetCharacterNickname()
{
}

simulated function GenerateSafeCharacterNames();

simulated function XComUnitPawn GetPawn()
{
}

function Vector GetLeftVector()
{
}

function Vector GetLeftVectorAtCoverPoint(XComCoverPoint Point, int iDirIdx)
{
}

function Vector GetRightVector()
{
}

function Vector GetRightVectorAtCoverPoint(XComCoverPoint Point, int iDirIdx)
{
}

function DecRefActionForPlayer(XGAction kAction, XComTacticalController kPlayerController)
{
}

simulated event ProcessNetExecActionQueue()
{
}

simulated function bool NetExecActionQueueIsExecuting(XGAction kAction)
{
}
simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, Vector vCameraPosition, Vector vCameraDir){}
simulated event OnUpdatedVisibility(bool bVisibilityChanged);
simulated event ApplyPsiEffectsToTarget(){}
simulated event OnKineticStrikeAnimNotify(){}
native function XComDestructibleActor ShouldBreakWindowBeforeFiring(Vector TargetLocation, int CoverDirectionIndex, XComWorldData.UnitPeekSide PeekSide);
native function GetStanceForInteraction(XComInteractiveLevelActor InteractLevelActor, name InteractSocketName, out int CoverDirectionIndex, out int PeekSide);
native simulated function bool CheckAbilitiesInitiallyReplicated();
simulated event OnAbilitiesInitiallyReplicated(){}
native simulated function XGAbility_Targeted GetAppliedAbility(int iAbility);
simulated function MPForceUpdateAbilitiesUI(){}
simulated event UpdateAbilitiesUI(){}
native simulated function bool IsAI();
native function BuildAbilities(optional bool bUpdateUI=true);
native simulated function bool ShouldAddMoveAbilities();
native simulated function AddMoveAbilities(XGTacticalGameCoreNativeBase GameCore, out array<XGAbility> arrAbilities);
native simulated function AddWeaponAbilities(XGTacticalGameCoreNativeBase GameCore, Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly);
native simulated function AddPerkSpecificAbilities(XGTacticalGameCoreNativeBase GameCore, out array<XGAbility> arrAbilities);
simulated event AddArmorAbilities(Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly){}
simulated event AddPsiAbilities(Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly){}
simulated event AddCharacterAbilities(Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly){}
simulated event GetNumPotentialMedikitTargets(out int iTargets){}
simulated event GetNumPotentialStabilizeTargets(out int iTargets){}
simulated event GetNumPotentialRepairSHIVTargets(out int iTargets){}
native simulated function ClearAbilities(optional bool bForLocalUseOnly);
native simulated function bool IsClosed();
native simulated function bool IsHardened();
native simulated function bool IsDead();
native simulated function bool AreDyingActionsInQueue();
native simulated function bool IsMovingNative();
native simulated function bool KillerInstinctPerkActive();
native simulated function bool IsCloseRange(Vector vLocation, optional bool bRelaxed, optional float fRangeMultiplier=1.0);
native simulated function bool IsInCloseCombatSpecialistRange(Vector vLoc);
native simulated function bool IsInRegenPheromoneRange(Vector vLoc);
native function AddBonus(int iBonus);
native function RemoveBonus(int iBonus);
native simulated function int FindInBuff(out int arr[EPerkType], int iBuff);
native function int AddBuff(out int arr[EPerkType], int iBuff);
native function int RemoveBuff(out int arr[EPerkType], int iBuff);
native simulated function int GetNumOfPerksInArray(out int perkArray[EPerkType]);
native simulated function bool WillToSurviveValid(XGAbility_Targeted kAbility);
native simulated function bool HasHeightAdvantageOver(XGUnit kTarget);
native function RemoveAllContextBuffs();
native function RemovePassiveBuffs();
native function RemoveAllBuffs();
native simulated function int WillTestChance(int iWillTest, int iMyMods, bool bUseArmorBonus, bool bUseMindShieldBonus, optional XGUnit kVersus, optional int iEvenStatsChanceToFail=50, optional out int iFinalWill);
native simulated function bool IsAffectedByAbility(int iAbility);
native simulated function bool IsInTelekineticField();
native simulated function bool IsPoisoned();
native simulated function bool CanBeHealedWithMedikit();
native simulated function bool IsApplyingAbility(int iAbility);
native function AddPenalty(int iPenalty);
native function RemovePenalty(int iPenalty);
native function AddPassive(int iPassive);
native function RemovePassive(int iPassive);
native function UpdateCoverBonuses(XGUnitNativeBase kTarget);
native simulated function bool HasPassive(int iBuff);
native simulated function bool HasBonus(int iBuff);
native simulated function bool HasPenalty(int iBuff);
native simulated function bool CanUseCover(optional bool bIgnoreFlight);
native simulated function SetCoverValue(int iNewCoverValue);
native function bool HasAirEvadeBonus();
native function bool HasNoCoverBonus();
native simulated function int GetTacticalSenseCoverBonus();
native simulated function int GetLowProfileCoverBonus();
simulated event int GetMaxPathLength(optional bool bIgnorePoison){}
simulated function bool IsATank(){}
simulated function bool IsAugmented(){}
reliable server function UpdateUnitBuffs(){}
event CallUpdateUnitBuffs(){}
simulated function PerformInventoryOperation(XComAnimNodeBlendByAction.EAnimAction animation, float BlendTime, InventoryOperation InvOperation, bool bRecord){}
simulated function SetFireStateData(int ShotIndex, const out FiringStateReplicationData ShotData){}
simulated function bool GetFireStateData(int ShotIndex, out FiringStateReplicationData ShotData){}
simulated function int GetNumShots(){}
simulated function SetNumShots(int SetNumShots){}
simulated function ValidateFiringStateFunctionCall(){}
native simulated function bool VisibleEnemyHasHeightAdvantageOn(out array<XGUnit> visibleUnits);
native simulated function bool IsInRiftVolume();
native simulated function bool IsPossessed();
native simulated function bool IsTracerBeamed();
native simulated function bool IsShredded();
native simulated function bool IsPsiInspired();
native simulated function bool HasHeightAdvantageOnAVisibleEnemy();
native simulated function bool IsTurnEndingAbility(int iAbility);
native simulated function int GetAggressionBonus();
native simulated function bool AbilityIsInList(int iAbility, array<XGAbility> arrAbilities);
native simulated function GenerateAbilities(int iAbility, Vector vLocation, out array<XGAbility> arrAbilities, optional XGWeapon kWeapon, optional bool bForLocalUseOnly);
native simulated function bool GenerateAbilities_CheckForFlyAbility(int iAbility, out array<XGAbility> arrAbilities, XGTacticalGameCoreNativeBase GameCore);
native simulated function bool GenerateAbilities_CheckForCloseAbility(int iAbility, out array<XGAbility> arrAbilities, XGTacticalGameCoreNativeBase GameCore);
native simulated function XGAbility FindAbility(int iType, XGUnit kTarget);
native simulated function bool IsMeleeOnly();
simulated function GetTargetsInRange(int iTargetType, int iRangeType, out array<XGUnitNativeBase> arrTargets, Vector vLocation, optional XGWeapon kWeapon, optional float fCustomRange, optional bool bNoLOSRequired, optional bool bSkipRoboticUnits, optional bool bSkipNonRoboticUnits, optional int eType){}
simulated event CallGetTargetsInRange(int iTargetType, int iRangeType, out array<XGUnitNativeBase> arrTargets, Vector vLocation, optional XGWeapon kWeapon, optional float fCustomRange, optional bool bNoLOSRequired, optional bool bSkipRoboticUnits, optional bool bSkipNonRoboticUnits, optional int eType){}
native simulated function bool IsAnimal();
native simulated function bool IsAbilityOnCooldown(int iAbility);
native simulated function bool RunAndGunPerkActive();
native simulated function bool RunAndGunUsedMove();
native simulated function bool DoubleTapPerkActive();
native simulated function int GetUnitMaxHP();
native simulated function int GetUnitHP();
native simulated function int GetShieldHP();
native simulated function int GetMaxShieldHP();
native simulated function bool IsPanicking();
native simulated function bool IsPanicked();
native simulated function bool IsWaitingToPanic();
native simulated function bool CanPanic(optional bool bUsingPsiPanicAbility);
native simulated function bool IsPanicActive(optional bool bUsingPsiPanicAbility);
native simulated function bool IsPsiLinkSource();
native simulated function bool IsPsiLinked(optional bool bAsTargetOnly);
native simulated function bool HasPerformedAbilityAgainstTarget(EAbility iAbility, XGUnit kTarget, bool bCurrentTurnOnly);
native simulated function bool HasCoverBonus(optional bool bActualCover);
native simulated function bool PrimaryWeaponHasAmmoForShot(XGAbility_GameCore kAbility);
native simulated function bool HasOverheadClearance(Vector vLocation, optional float fOverheadHeight=320.0);
native simulated function bool CanLaunchFromHere();
native simulated function RemoveFromAbilityArray(XGAbility Ability);
native simulated function CacheCoverDirectionPeekInfo(optional bool bForce);
native simulated function bool ImmuneToFire();
native simulated function bool DoClimbOverCheck(const out Vector Destination, optional bool bUseDestinationZ);
simulated function SetHiding(bool bHide){}
native function bool GetDirectionInfoForTarget(XGUnit Target, out int Direction, out UnitPeekSide PeekSide, out int bCanSeeFromDefault);
native function bool GetDirectionInfoForPosition(Vector Position, out int Direction, out UnitPeekSide PeekSide, out int bCanSeeFromDefault, optional bool bRequireVisibility);
simulated function CheckAgainstVolumes(){}
simulated event OnUnitChangedTileDuringMovement(){}
simulated function bool IsInitialReplicationComplete(){}
simulated event SetBETemplate(){}
native simulated function int NumCustomFireNotifiesRemaining();
native simulated function bool IsHumanoid();
native simulated function bool IsImmuneToStrangle();
simulated event NotifyDistortionFieldGained(){}
simulated event NotifyDistortionFieldLost(){}
simulated function DestroyXComWeapons(){}
simulated function DestroyPathingPawn(){}
simulated function ProcessNewPosition(optional bool bEvaluateStance=true){}
simulated event CallProcessNewPosition(){}
simulated function CheckMimeticSkinForUnhide(){}
simulated event EExitCoverTypeToUse GetExitCoverType(XGUnit PrimaryTarget, const out Vector TargetLoc, out int UseCoverDirectionIndex, out UnitPeekSide UsePeekSide, out int bCanSeeFromDefault){}
native simulated function bool IsImmuneToPoison();simulated function int GetCharType();
simulated event bool IsDeadOrDying(){}
native simulated function bool IsSavedCivilian();
simulated function bool IsAbortWithWoundConditionValid(XGAbility_Targeted kAbility)
{}
simulated event ClearAppliedAbilitiesWithProperty(int iAbilityProperty)
{}