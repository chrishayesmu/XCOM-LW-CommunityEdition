class XGUnit extends XGUnitNativeBase
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

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
var protected bool m_bMoraleLevelChanged;
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
var privatewrite bool m_bCanOpenWindowsAndDoors;
var bool m_bPoisonedByThinman;
var bool m_bInfiniteGrenades;
var privatewrite bool m_bShowMouseOverDisc;
var bool m_bIgnoreCloseCombatNextMove;
var bool m_bWaitForCloseCombatDamage;
var bool m_bFailedCloseCombatCheck;
var bool m_bSeenBetterAlien;
var bool m_bAddClientsidePathAction;
var repnotify bool m_bReactionFireAutoZoomAddSelf;
var privatewrite repnotify bool m_bPushStatePanicking;
var privatewrite bool m_bGotoStateInactiveFromStatePanicked;
var bool m_bActivateAfterPanickedComplete;
var privatewrite bool m_bPanicMoveFinished;
var privatewrite bool m_bServerPanicMoveFinished;
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
var protected array<EMoraleEvent> m_arrMoraleEventsThisTurn;
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
var privatewrite repnotify EDiscState m_eDiscState;
var EUnitPawn_OpenCloseState m_ePawnOpenCloseState;
var privatewrite repnotify EPerkType m_eReplicateDeactivatePerkType;
var privatewrite export editinline StaticMeshComponent m_kDiscMesh;
var privatewrite export editinline StaticMeshComponent m_kBoxMesh;
var privatewrite MaterialInstanceTimeVarying m_kBoxMeshUnitSelectMaterial;
var privatewrite MaterialInstanceTimeVarying m_kBoxMeshEnemySelectMaterial;
var privatewrite export editinline StaticMeshComponent m_kFlyingRing;
var privatewrite TextureFlipBook m_kDiscAnim;
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
var protected export editinline ParticleSystemComponent RiftPSC;
var protected export editinline ParticleSystemComponent RiftEndPSC;
var protected export editinline ParticleSystemComponent TKFieldPSC;
var protected export editinline ParticleSystemComponent TKFieldEndPSC;
var protected export editinline ParticleSystemComponent BattleScannerPSC;
var protected export editinline ParticleSystemComponent BattleScannerEndPSC;
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
var privatewrite repnotify repretry ReplicateActivatePerkData m_kReplicateActivatePerkData;
var private array<EAttentionNeeded> m_arrAttentionNeeds;

delegate bool CoverValidator(Vector vCoverLoc)
{
}

// Since this is notplaceable, I just deleted the defaultproperties instead of cleaning them up.
// Shouldn't make any difference to the UDK