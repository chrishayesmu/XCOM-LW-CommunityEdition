class XGTacticalGameCore extends XGTacticalGameCoreNativeBase
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

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

var privatewrite bool m_bInitialized;
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

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}