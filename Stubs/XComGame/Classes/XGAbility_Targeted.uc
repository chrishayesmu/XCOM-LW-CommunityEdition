class XGAbility_Targeted extends XGAbility
    native(Core)
    notplaceable;
//complete stub

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

struct native TShotResult
{
    var string strTargetName;
    var int iPossibleDamage;
    var int iPossibleCritDamage;
    var bool bKillshot;
    var int iOffenseDamage;
    var int iDefenseDamage;
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
};
struct native TUnitTarget
{
    var XGUnit m_kTarget;
    var bool m_bClearedAffectingAbility;
    var bool m_bClearedAffectingEffect;
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
var repnotify bool m_bRemoveAbility;
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
var private repnotify InitialReplicationData_XGAbility_Targeted m_kInitialReplicationData_XGAbility_Targeted;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAbility_Targeted;

    if(bNetDirty && Role == ROLE_Authority)
        m_aTargets, m_bCritical, 
        m_bHit, m_bHit_NonUnitTarget, 
        m_bReflected, m_bRemoveAbility, 
        m_iActualDamage, m_iActualEnvironmentDamage, 
        m_iCriticalChance, m_iHitChance, 
        m_kVolume, m_shotHUDCritChanceStats, 
        m_shotHUDDMGStats, m_shotHUDHitChanceStats;
}

function bool ShouldSaveForCheckpoint(){}
function ApplyCheckpointRecord(){}
static final simulated function int TShotInfo_ToString(optional TShotInfo kShotInfo){}
simulated event ReplicatedEvent(name VarName){}
native function SetShotTitleFromPerkType(XComPerkManager kPerkMan, TShotHUDStat kShot);
function DecRefRemovingClient(XComTacticalController kTacticalController){}
simulated function ClearMultiShotTargets(){}
simulated function AddMultiShotTarget(XGUnit kTarget){}
native simulated function XGUnit GetPrimaryTarget();
native simulated function int GetNumTargets();
native simulated function int GetEmptyTargetIndex();
simulated function int FindTargetIndex(XGUnit kTarget){}
simulated function bool GetTargets(out array<XGUnit> aTargets){}
native function ShotInit(int iAbility, array<XGUnit> arrTargets, XGWeapon kWeapon, optional bool bReactionFire);
event FillInitialReplicationStruct(array<XGUnit> arrTargets){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function OnProjectileImpact(XComProjectile kProjectile){}
native function bool InternalCheckAvailable();
final simulated function RemoveAbility(){}
final simulated event RemoveAbilityFromTarget(out TUnitTarget kUnitTarget){}
final simulated event RemoveEffectsFromTarget(out TUnitTarget kUnitTarget){}
simulated function string GetFlankText(){}
simulated function string GetDistanceText(){}
simulated function int GetHitChance(){}
simulated function int GetCriticalChance(){}
simulated function GetUIHitChance(out int iUIHitChance, out int iUICriticalChance){}
function int GraduatedOdds(int iHitChance, XGPlayer kHumanPlayer, bool bCantLose){}
function int AdjustToHit(int iHitChance){}
simulated function int GetScatterChance(float fUnrealDist){}
function RollForHit(XGAction_Fire kFireAction){}
simulated function EndTurnCheck(){}
function RollForCritical(){}
simulated function bool IsHit(){}
simulated function bool IsCritical(){}
simulated function bool ShouldShowPercentage(){}
simulated function bool ShouldShowCritPercentage(){}
simulated function bool IsReflected(){}
simulated function bool IsFreeAiming(){}
simulated function bool CanFreeAim(){}
simulated function SetFreeAim(bool bFreeAim){}
reliable server function ServerSetFreeAim(bool bFreeAim){}
native function int CalcHitModFromPerks(int iHitChance, float fDistanceToTarget, bool heightAdvantage);
native function int CalcCritModFromPerks(XGAbility_Targeted kAbility, int iCritChance, float fDistanceToTarget, bool heightAdvantage);
native function int CalcHitChance();
native function int CalcCriticalChance();
native simulated function int CalcSuppression();
simulated function int GetPossibleDamage(){}
function string GetWeaponName(){}
function int GetPossibleEnvironmentalDamage(){}
function CalcDamage(){}
native simulated function int GetPrecisionShotPerkDamageDamageAdd();
native simulated function int GetMayhemPerkBonusDamage();
native simulated function int GetXenobiologyOverlaysBonusDamage();
native simulated function AddShotHUDStat(XGAbility_Targeted.ShotHUDStatType StatType, const out TShotHUDStat kStat);
native simulated function AddDamageStat(out float BaseDamage, float fDelta, optional string strTitle=" | ", optional XGTacticalGameCoreNativeBase.EPerkType iPerk);
native simulated function AddHitChanceStat(out int iHitChance, int iDelta, optional string strTitle=" | ", optional XGTacticalGameCoreNativeBase.EPerkType iPerk, optional string strBuffTitleForce);
native simulated function AddCritChanceStat(out int iCritChance, int iDelta, optional string strTitle=" | ", optional XGTacticalGameCoreNativeBase.EPerkType iPerk);
native simulated function int CalcOverallDamageModFromPerk(float BaseDamage);
simulated function int GetActualDamage(){}
simulated function int GetActualEnvironmentalDamage(){}
simulated function int CalcPsiLanceDamage(int iBaseDamage){}
simulated function bool AI_HasPriorityOver(XGAbility_Targeted kAltAbility){}
simulated function GetShotSummaryModFromPerks(out TShotResult kResult, out TShotInfo kInfo){}
simulated function GetShotSummary(out TShotResult kResult, out TShotInfo kInfo){}
simulated function GetCritSummary(out TShotResult kResult, out TShotInfo kInfo){}
simulated function GetCritSummaryModFromPerks(out TShotResult kResult, out TShotInfo kInfo){}
simulated function string BuildModString(int iValue, string _strName, optional bool bPercentage){}
function ApplyCost(){}
simulated function bool IsBlasterLauncherShot(){}
simulated function bool IsRocketShot(){}
simulated function bool CanFireWeapon(){}
simulated event bool CanTargetUnit(XGUnit kUnit){}
simulated function XComPerkManager PERKS(){}
native simulated function int DurationExisted();
