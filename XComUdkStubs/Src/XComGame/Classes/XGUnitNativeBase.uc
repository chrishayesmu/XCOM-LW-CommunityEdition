class XGUnitNativeBase extends Actor
    native(Unit)
    nativereplication
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

const MAX_SUPPRESSIONEXECUTING_ENEMIES = 16;
const MAX_SUPPRESSING_ENEMIES = 16;
const MAX_SUPPRESSING_TARGETS = 16;
const MAX_VISIBLE_ENEMIES = 16;
const MAX_VISIBLE_FRIENDS = 16;
const MAX_ENEMIES_SEEN_BY = 16;
const MAX_FRIENDS_SEEN_BY = 16;
const MAX_ENEMIES_ENGAGED_BY = 16;
const MAX_ENEMIES_IN_RANGE = 16;
const MAX_FRIENDS_IN_RANGE = 16;
const MAX_CIVILIANS_IN_RANGE = 16;
const MAX_VISIBLE_CIVILIANS = 32;
const MAX_ENEMIES_IN_CLOSE_RANGE = 16;
const MAX_ENEMIES_REVEALED_WHILE_MOVING = 16;
const MAX_FLANKING_UNITS = 16;
const MAX_ABIL_AFFECTING = 64;
const MAX_NUM_ABILITIES = 64;
const MAX_ABIL_APPLIED = 64;
const MIN_DELAY_UNIT_SPEECH = 0.25f;
const MAX_DELAY_UNIT_SPEECH = 4.0f;

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
    var ELocation m_eDynamicSpawnWeaponSlotLocation;
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

    structdefaultproperties
    {
        m_iDamage=-1
        m_bAttackerVisibleToEnemy=true
        m_bProjectileWillBeVisibleToEnemy=true
    }
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
var protected repnotify XGCharacter m_kCharacter;
var protected repnotify XComUnitPawnNativeBase m_kPawn;
var XComPathingPawn m_kPathingPawn;
var protected XGInventoryNativeBase m_kInventory;
var XGActionQueue m_kActionQueue;
var protected XGNetExecActionQueue m_kNetExecActionQueue;

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
var private bool m_bAbilitiesInitiallyReplicated;
var protectedwrite bool m_bBuildAbilitiesTriggeredFromVisibilityChange;
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
var protected bool m_bIsInOverwatch;
var protectedwrite bool m_bInCinematicMode;
var bool m_bInCinematicKineticStrikeDeath;
var bool m_bCelebrateAfterKill;
var bool bSteppingOutOfCover;
var bool bNeedsLowCoverStepOut;
var bool bChangedWeapon;
var protectedwrite bool m_bFlankDataWatchVariable;
var privatewrite repnotify bool m_bEnableBioElectricParticles;

var XGAction m_kCurrAction;
var protected XGSquadNativeBase m_kSquad;
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
var repnotify repretry TDynamicSpawnedWeaponReplicationInfo m_kDynamicSpawnedSmokeGrenade;
var repnotify repretry TDynamicSpawnedWeaponReplicationInfo m_kDynamicSpawnedBattleScanner;
var protectedwrite array<XComInteractPoint> m_arrInteractPoints;
var repnotify int m_iNumAbilities;
var repnotify XGAbility m_aAbilities[64];
var XGAbility_Targeted m_kCustomAbility;
var protected int m_iNumAbilitiesApplied;
var protected XGAbility_Targeted m_aAbilitiesApplied[64];
var int m_iNumAbilitiesOnCooldown;
var array<XGAbility> m_aNetAbilitiesWaitingToBeDestroyed;
var array<XGAbility> m_aNetCustomAbilitiesWaitingToBeDestroyed;
var protected int m_iNumAbilitiesAffecting;
var protected XGAbility_Targeted m_aAbilitiesAffecting[64];
var int m_iMovesActionsPerformed;
var protected repnotify int m_iMoves;
var protected repnotify int m_iUseAbilities;
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
var protected repnotify XGUnitNativeBase m_arrSuppressingEnemies[16];
var protected repnotify int m_numSuppressingEnemies;
var protected repnotify XGUnitNativeBase m_arrSuppressionTargets[16];
var protected repnotify int m_numSuppressionTargets;
var protected repnotify XGUnitNativeBase m_arrSuppressionExecutingEnemies[16];
var protected repnotify int m_numSuppressionExecutingEnemies;
var privatewrite UnitDirectionInfo PositionDirectionInfo;
var Vector RestoreLocation;
var Vector RestoreHeading;
var XGAction_EnterCover StoredEnterCoverAction;
var XGWeapon PriorMecWeapon;
var array<InventoryOperation> InventoryOperations;
var protected FiringStateReplicationData m_arrFiringStateRepDatas[EXGAbilityNumTargets];
var protected int NumShots;
var privatewrite array<XGUnit> m_arrVisibleEnemies;
var privatewrite array<XGUnit> m_arrVisibleFriends;
var privatewrite array<XGUnit> m_arrEnemiesSeenBy;
var privatewrite array<XGUnit> m_arrFriendsSeenBy;
var privatewrite array<XGUnit> m_arrEnemiesEngagedBy;
var privatewrite array<UnitDirectionInfo> m_arrUnitDirectionInfos;
var privatewrite array<XGUnit> m_arrFriendsInRange;
var privatewrite array<XGUnit> m_arrCiviliansInRange;
var privatewrite array<XGUnit> m_arrVisibleCivilians;
var privatewrite array<XGUnit> m_arrEnemiesInCloseRange;
var privatewrite array<XGUnit> m_arrEnemiesRevealedWhileMoving;
var privatewrite array<XGUnit> m_arrFlankingUnits;
var private repnotify const XGUnitNativeBase m_arrVisibleEnemiesReplicated[16];
var private const int m_iNumVisibleEnemiesReplicated;
var private repnotify const XGUnitNativeBase m_arrVisibleFriendsReplicated[16];
var private const int m_iNumVisibleFriendsReplicated;
var private repnotify const XGUnitNativeBase m_arrEnemiesSeenByReplicated[16];
var private const int m_iNumEnemiesSeenByReplicated;
var private repnotify const XGUnitNativeBase m_arrFriendsSeenByReplicated[16];
var private const int m_iNumFriendsSeenByReplicated;
var private repnotify const XGUnitNativeBase m_arrEnemiesEngagedByReplicated[16];
var private const int m_iNumEnemiesEngagedByReplicated;
var private repnotify const UnitDirectionInfo m_arrUnitDirectionInfosReplicated[16];
var private const int m_iNumUnitDirectionInfosReplicated;
var private repnotify const XGUnitNativeBase m_arrFriendsInRangeReplicated[16];
var private const int m_iNumFriendsInRangeReplicated;
var private repnotify const XGUnitNativeBase m_arrCiviliansInRangeReplicated[16];
var private const int m_iNumCiviliansInRangeReplicated;
var private repnotify const XGUnitNativeBase m_arrVisibleCiviliansReplicated[32];
var private const int m_iNumVisibleCiviliansReplicated;
var private repnotify const XGUnitNativeBase m_arrEnemiesInCloseRangeReplicated[16];
var private const int m_iNumEnemiesInCloseRangeReplicated;
var private repnotify const XGUnitNativeBase m_arrEnemiesRevealedWhileMovingReplicated[16];
var private const int m_iNumEnemiesRevealedWhileMovingReplicated;
var private repnotify const XGUnitNativeBase m_arrFlankingUnitsReplicated[16];
var private const int m_iNumFlankingUnitsReplicated;
var private string BioElectricParticleName;
var private export editinline ParticleSystemComponent m_BioElectricPSC;
var protected export editinline ParticleSystemComponent m_OnFirePSC;

defaultproperties
{
    m_bReactionFireStatus=true
    m_iLastTurnFireDamaged=-1
    FlankingAngle=180.0
    ClaimDistance=32.0
    CornerClaimDistance=42.0
    BioElectricParticleName="FX_GeneMods.P_Bioelectric_Skin_Enemy_Aura"
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true

    begin object name=BEPSC class=ParticleSystemComponent
        bAutoActivate=false
        bIgnoreOwnerHidden=true
    end object

    m_BioElectricPSC=BEPSC
    Components.Add(BEPSC)

    begin object name=OnFirePSC class=ParticleSystemComponent
        bAutoActivate=false
    end object

    m_OnFirePSC=OnFirePSC
    Components.Add(OnFirePSC)
}