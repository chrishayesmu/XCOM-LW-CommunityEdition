class XGAbility_Targeted extends XGAbility
    native(Core)
    notplaceable
    hidecategories(Navigation);

const SCATTER_MIN_TILES = 2.5;
const SCATTER_RAND_TILES = 1.5;
const SCATTER_BUFFER = 10;
const SCATTER_MIN_DEGREES = 10;
const SCATTER_RAND_DEGREES = 15;
const MAX_SHOTHUDSTATS = 16;

enum EXGAbilityNumTargets
{
    EXGAbilityNumTargets,
    EXGAbilityNumTargets_1,
    EXGAbilityNumTargets_2,
    EXGAbilityNumTargets_3,
    EXGAbilityNumTargets_4,
    EXGAbilityNumTargets_5,
    EXGAbilityNumTargets_6,
    EXGAbilityNumTargets_7,
    EXGAbilityNumTargets_8,
    EXGAbilityNumTargets_9,
    EXGAbilityNumTargets_10,
    EXGAbilityNumTargets_11,
    EXGAbilityNumTargets_12,
    EXGAbilityNumTargets_13,
    EXGAbilityNumTargets_14,
    EXGAbilityNumTargets_15,
    EXGAbilityNumTargets_MAX
};

enum ShotHUDStatType
{
    eType_Damage,
    eType_HitChance,
    eType_CritChance,
    eType_MAX
};

struct native TUnitTarget
{
    var XGUnit m_kTarget;
    var bool m_bClearedAffectingAbility;
    var bool m_bClearedAffectingEffect;
};

struct CheckpointRecord_XGAbility_Targeted extends CheckpointRecord
{
    var bool m_bTargetUpkeep;
    var XComProjectile m_kProjectile;
    var XGVolume m_kVolume;
    var XGWeapon m_kWeapon;
    var TUnitTarget m_aTargets[EXGAbilityNumTargets];
    var bool m_bSave;
};

struct native TShotResult
{
    var string strTargetName;
    var int iPossibleDamage;
    var int iPossibleCritDamage;
    var bool bKillshot;
    var int iOffenseDamage;
    var int iDefenseDamage;
};

struct native TShotInfo
{
    var string strTitle;
    var array<string> arrHitBonusStrings;
    var array<int> arrHitBonusValues;
    var array<string> arrHitPenaltyStrings;
    var array<int> arrHitPenaltyValues;
    var array<string> arrCritBonusStrings;
    var array<int> arrCritBonusValues;
    var array<string> arrCritPenaltyStrings;
    var array<int> arrCritPenaltyValues;
};

struct native TShotHUDStat
{
    var int m_iAmount;
    var int m_iPerk;
    var init string m_strTitle;
};

struct native TUnitTargetInfo
{
    var XGUnit m_aTarget;
    var bool m_bTargetNone;

    structdefaultproperties
    {
        m_bTargetNone=true
    }
};

struct native InitialReplicationData_XGAbility_Targeted
{
    var TUnitTargetInfo m_aTargets[EXGAbilityNumTargets];
    var XGWeapon m_kWeapon;
    var bool m_bWeaponNone;
    var bool m_bHasFlank;
    var bool m_bHasOpenTarget;
    var bool m_bHasExecutioner;
    var bool m_bHasHeightAdvantage;
    var float m_fDistanceToTarget;
    var int m_iHitChance;
    var int m_iCriticalChance;
    var bool m_bForceHit;
    var bool m_bFreeAiming;
};

var XGWeapon m_kWeapon;
var TUnitTarget m_aTargets[EXGAbilityNumTargets];
var bool m_bHasFlank;
var bool m_bHasHeightAdvantage;
var bool m_bHasOpenTarget;
var bool m_bHasExecutioner;
var bool m_bHit;
var bool m_bCritical;
var bool m_bReflected;
var bool m_bIgnoreCalculation;
var bool m_bHit_NonUnitTarget;
var bool m_bFreeAiming;
var bool m_bTargetUpkeep;
var private bool m_bInitialReplicationDataReceived_XGAbility_Targeted;
var privatewrite repnotify bool m_bRemoveAbility;
var bool m_bIsAbilityRemoving;
var private bool m_bDestroyingViaRemovedClient;
var bool m_bSave;
var float m_fDistanceToTarget;
var int m_iHitChance;
var int m_iCriticalChance;
var int m_iHitChance_NonUnitTarget;
var int m_iActualDamage;
var int m_iActualEnvironmentDamage;
var XComProjectile m_kProjectile;
var XGVolume m_kVolume;
var Vector m_vTargetLocation;
var int m_iPrimaryMultiShotTarget;
var const localized string m_strFlankText;
var const localized string m_strUnknownWeapon;
var const localized string m_strPenaltySnapShot;
var const localized string m_strBonusTracerBeams;
var const localized string m_strBonusAim;
var const localized string m_strBonusFlanking;
var const localized string m_strPenaltyLowCover;
var const localized string m_strPenaltyHighCover;
var const localized string m_strHunker;
var const localized string m_strPoison;
var const localized string m_strPenaltyDefense;
var const localized string m_strPenaltyEvasion;
var const localized string m_strHeightBonus;
var const localized string m_strItemBonus;
var const localized string m_strItemPenalty;
var const localized string m_strChanceToStun;
var const localized string m_strDroneHack;
var const localized string m_strCheating;
var const localized string m_strBonusCritWeapon;
var const localized string m_strBonusCritPistol;
var const localized string m_strBonusCritEnemyNotInCover;
var const localized string m_strBonusCritDistance;
var const localized string m_strBonusCritPrecision;
var const localized string m_strBonusCritAggression;
var const localized string m_strBonusCritCombatDrugs;
var const localized string m_strPenaltyCritEnemyHardened;
var TShotHUDStat m_shotHUDDMGStats[16];
var TShotHUDStat m_shotHUDHitChanceStats[16];
var TShotHUDStat m_shotHUDCritChanceStats[16];
var private repnotify repretry InitialReplicationData_XGAbility_Targeted m_kInitialReplicationData_XGAbility_Targeted;

defaultproperties
{
    m_iHitChance=100
}