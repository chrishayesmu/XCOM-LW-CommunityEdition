class XGTacticalGameCore extends XGTacticalGameCoreNativeBase
    hidecategories(Navigation)
    config(GameCore)
    notplaceable;
//complete stub

enum EUnexpandedLocalizedStrings
{
    eULS_Speed,
    eULS_LightningReflexesUsed,
    eULS_UnitNotStunned,
    eULS_Panicking,
    eULS_Poisoned,
    eULS_Shredded,
    eULS_TracerBeam,
    eULS_AbilityErrMultiShotFail,
    eULS_AbilityCurePoisonFlyover,
    eULS_AbilityOpportunistFlyover,
    eULS_ReactionFireActive,
    eULS_ReactionFireDisabled,
    eULS_InTheZoneProc,
    eULS_DoubleTapProc,
    eULS_ExecutionerProc,
    eULS_SecondaryHeartProc,
    eULS_NeuralDampingProc,
    eULS_NeuralFeedbackProc,
    eULS_AdrenalNeurosympathyProc,
    eULS_ReactiveTargetingSensorsProc,
    eULS_RegenPheromones,
    eULS_AdrenalineSurge,
    eULS_Strangled,
    eULS_Stealth,
    eULS_ShivModuleDisabled,
    eULS_CoveringFireProc,
    eULS_CloseCombatProc,
    eULS_SentinelModuleProc,
    eULS_CatchingBreath,
    eULS_FlashBangDisorient,
    eULS_FlashBangDaze_DEPRECATED,
    eULS_StealthChargeBurn,
    eULS_StealthDeactivated,
    eULS_Immune,
    eULS_AutoThreatAssessmentFlyover,
    eULS_AdvancedFireControlFlyover,
    eULS_WeaponDisabled,
    eULS_EMPDisabled,
    eULS_MAX
};

enum EExpandedLocalizedStrings
{
    eELS_UnitHoverFuel,
    eELS_UnitHoverEnabled,
    eELS_UnitReflectedAttack,
    eELS_WeaponOverheated,
    eELS_WeaponCooledDown,
    eELS_AbilityErrFailed,
    eELS_UnitInCloseCombat,
    eELS_UnitReactionShot,
    eELS_UnitCriticallyWounded,
    eELS_SoldierDied,
    eELS_TankDied,
    eELS_UnitIsStunned,
    eELS_UnitRecovered,
    eELS_UnitStabilized,
    eELS_UnitBleedOut,
    eELS_UnitBledOut,
    eELS_UnitReturnDeath,
    eELS_UnitBoneMarrowHPRegen,
    eELS_UnitRepairServosRegen,
    eELS_UnitPsiDrainTarget,
    eELS_UnitPsiDrainCaster,
    eELS_MAX
};

enum EGameEvent
{
    eGameEvent_Kill,
    eGameEvent_Wound,
    eGameEvent_Heal,
    eGameEvent_Turn,
    eGameEvent_MissionComplete,
    eGameEvent_SpecialMissionComplete,
    eGameEvent_ZeroDeadSoldiersBonus,
    eGameEvent_TargetResistPsiAttack,
    eGameEvent_KillMindControlEnemy,
    eGameEvent_SuccessfulMindControl,
    eGameEvent_SuccessfulMindFray,
    eGameEvent_SuccessfulInspiration,
    eGameEvent_AssistPsiInspiration,
    eGameEvent_Sight,
    eGameEvent_SuccessfulPsiPanic,
    eGameEvent_MAX
};

enum EMoraleEvent
{
    eMoraleEvent_Wounded,
    eMoraleEvent_AllyCritical,
    eMoraleEvent_AllyKilled,
    eMoraleEvent_ImportantAllyKilled,
    eMoraleEvent_AllyTurned,
    eMoraleEvent_ZombieHatch,
    eMoraleEvent_AllyPanics,
    eMoraleEvent_MutonIntimidate,
    eMoraleEvent_Disoriented,
    eMoraleEvent_SetOnFire,
    eMoraleEvent_MAX
};

var bool m_bInitialized;
var init const localized string m_aUnexpandedLocalizedStrings[EUnexpandedLocalizedStrings];
var init const localized string m_aExpandedLocalizedStrings[EExpandedLocalizedStrings];
var init const localized string m_aSoldierClassNames[ESoldierClass];
var init const localized string m_aSoldierMPTemplate[EMPTemplate];
var init const localized string m_aSoldierMPGeneModTemplate[EMPGeneModTemplateType];
var init const localized string m_aSoldierMPGeneModTemplateTacticalText[EMPGeneModTemplateType];
var init const localized string m_aSoldierMPMECSuitTemplate[EMPMECSuitTemplateType];
var init const localized string m_aSoldierMPMECSuitTemplateTacticalText[EMPMECSuitTemplateType];
var init const localized string m_aSoldierMPTemplateTacticalText[EMPTemplate];
var init const localized string GeneMods;
var init const localized string EmptyLoadout;
var init const localized string UnknownCauseOfDeathString;
var int m_iDifficulty;
var config array<config int> m_iPsiXPLevels;
var config array<config int> m_iSoldierXPLevels;


simulated function string GetUnexpandedLocalizedMessageString(EUnexpandedLocalizedStrings eString){}
static final function XGTacticalGameCoreData.EWeaponClass GetWeaponClass(EItemType eItem){}
simulated function TWeapon GetTWeapon(int iWeapon){}
simulated function TArmor GetTArmor(int iArmor){}
simulated function string GetSoldierClassName(int eClass){}
simulated function string GetMPTemplateName(int eTemplate){}
simulated function string GetMPGeneModTemplateName(int eTemplate){}
simulated function string GetMPMECSuitTemplateName(int eTemplate){}
function int GetMPTemplateByName(string strTemplate){}
simulated function string GetLocalizedItemName(EItemType Idx){}
simulated function bool IsBetterAlien(TSoldier kSoldier, int iTargetCharType, optional bool bCheckSoldierRank=true){}
simulated function int GetBasicKillXP(XGUnit kUnit){}
simulated function int GetBetterAlienKillXP(XGUnit kUnit){}
simulated function bool DeservesBetterAlienBonus(XGUnit kSoldier){}
simulated function int CalcXP(XGUnit kSoldier, int iEvent, XGUnit kVictim){}
simulated function int CalcWillValue(int iEvent, TCharacter kCharacter, out int aCurrentStats[ECharacterStat]){}
simulated function int GetXPRequired(int iRank){}
simulated function int GetPsiXPRequired(int iRank){}
simulated function SetDifficulty(int iDifficulty){}
simulated event Init(){}
simulated function BuildWeapons(){}
simulated function BuildArmors(){}
simulated function BuildCharacters(){}
simulated function bool CalcWeaponOverheated(int iWeapon, int iCurrentOverheatChance){}
simulated function int GetOverheatIncrement(XGUnit kUnit, int iWeapon, int iAbility, out TCharacter kCharacter, optional bool bReactionFire){}
simulated function int CalcHitChance_NonUnitTarget(int iWeapon, TCharacterBalance kShooter, int aShooterStats[ECharacterStat], int fDistanceToTarget, bool bIsPoisoned){}
simulated function bool CalcReflection(int iAbilityType, int iWeaponType, out TCharacter kShooter, out TCharacter kTarget, bool bIsHit){}
function bool RollForHit_NonUnitTarget(float fChance, out TCharacter kShooter, out float fRoll){}
function bool RollForHit(float fChance, out TCharacter kShooter, out TCharacter kTarget, out float fRoll){}
function bool RollForCrit(float fChance, out TCharacter kShooter, out TCharacter kTarget, out float fRoll){}
function int CalcOverallDamage(int iWeapon, int iCurrDamageStat, optional bool bCritical, optional bool bReflected){}
simulated function int GetMaxOverwatchBonus(int iCharType){}
simulated function int GetMaxReaction(out TCharacter kCharacter){}
simulated function int CalcEnvironmentalDamage(int iWeapon, int iAbility, out TCharacter kCharacter, out int aCurrentStats[ECharacterStat], optional bool bCritical, optional bool bHasHeightBonus, optional float fDistanceToTarget, optional bool bUseFlankBonus){}
simulated function float CalcRelativeHeightWeaponRangeBonus(out TCharacter kHighCharacter, out int aHighCurrentStats[ECharacterStat], int iHighWeapon, out TCharacter kLowCharacter, out int aLowCurrentStats[ECharacterStat]){}
simulated function CalcRelativeHeightBonus(out TCharacter kHighCharacter, out int aHighCurrentStats[ECharacterStat], int iHighWeapon, out TCharacter kLowCharacter, out int aLowCurrentStats[ECharacterStat], out int aRelativeBonusesGranted[ECharacterStat]);
simulated function CalcStaticHeightBonus(float fUnitZHeight, out TCharacter kHighCharacter, out int aHighCurrentStats[ECharacterStat], int iHighWeapon, out int aRelativeBonusesGranted[ECharacterStat]){}
function bool TryStunned(XGUnit kVictim, XGAction kAction){}
function bool CanBeStunned(XGUnit kVictim){}
function bool CanBeHacked(XGUnit kVictim, XGAction kAction){}
simulated function int GetMoveReactionCost(){}
function bool TriggeredReactionFire(int iTargetReaction, int iShooterReaction){}
function bool CalcCriticallyWounded(XGUnit kUnit, out TCharacter kCharacter, out int aCurrentStats[ECharacterStat], int iDamageAmount, int iRank, bool bIsVolunteer, bool bHasSecondaryHeart, out int iSavedBySecondaryHeart, const out Vector CharLocation, const out ETeam TeamVis){}
simulated function int GetUpgradeAbilities(int iRank, int iPersonality){}
simulated function int GetExtraArmorStatBonus(int iStat, int iArmor){}
simulated function int GetBackpackStatBonus(int iStat, array<int> arrBackPackItems, out TCharacter kCharacter){}
simulated function GetInventoryStatModifiers(out int aModifiers[ECharacterStat], out TCharacter kCharacter, EItemType iEquippedWeapon, array<int> arrBackPackItems){}
simulated function string GetLoadoutDescription(TInventory kInventory){}
static simulated function int GetPrimaryWeapon(TInventory kInventory){}
simulated function EItemType GetEquipWeapon(TInventory kInventory){}
simulated function GetBackpackItemArray(TInventory kInventory, out array<int> arrBackPackItems){}
simulated function BuildWeapon(const out TConfigWeapon kW){}
simulated function BuildArmor(const out TConfigArmor kA){}
simulated function BuildCharacter(const out TConfigCharacter ConfigChar){}
simulated function GetCharacterBalanceMods(ECharacter CharType, out TCharacterBalance Mods){}
simulated function int GetHPAdjustByDifficulty(int iCharacterType){}
simulated function ModifyStatsByDifficulty(out TCharacter kCharacter){}
simulated function bool CharacterIsPsionic(const out TCharacter kCharacter){}
simulated function bool WeaponHasProperty(int iWeapon, int iWeaponProperty){}
simulated function bool WeaponHasAbility(int iWeapon, int iAbility){}
simulated function bool ArmorHasAbility(int iArmor, int iAbility){}
simulated function bool CharacterHasAbility(out TCharacter kCharacter, int iAbility){}
simulated function bool CharacterHasUpgrade(out TCharacter kCharacter, int iUpgrade){}
simulated function bool CharacterHasTraversal(const out TCharacter kCharacter, int iTraversal){}
static simulated function string GetRankString(int iRank, optional bool bAbbreveiated, optional bool bPsi){}
function XGTacticalGameCoreData.eWeaponRangeCat GetWeaponCatRange(EItemType eWeapon){}
function int GenerateWeaponFragments(int iItem){}
simulated function bool ItemIsAccessory(int iItem){}
simulated function bool ItemIsWeapon(int iItem){}
simulated function bool ItemIsArmor(int iItem){}
simulated function bool ItemIsMecArmor(int iItem){}
simulated function bool ItemIsShipWeapon(int iItem){}
static function EItemCardAbility ConvertAbilityIdToItemCard(EAbility conv){}
function int CalcRiftDamage(XGUnit kAttacker, XGUnit kVictim, bool bInitialBlast){}
function int CalcPsiLanceDamage(XGUnit kAttacker, XGUnit kVictim){}
static final function bool Roll(int iChance){}
static final function LevelUpStats(ESoldierClass eSoldierClassType, int iSoldierRank, out int ioStatHealth, out int ioStatOffense, out int ioStatWill, out int ioStatMobility, out int ioStatDefense, bool bRandStatIncrease, bool bIsMultiplayer){}
function ClearDummyCharFromPodList(out array<TAlienPod> arrPodList){}
function ClearDummyCharFromSquad(out TAlienSquad kSquad){}
simulated function bool AbilityRequiresProjectilePreview(XGAbility_Targeted kAbility){}
