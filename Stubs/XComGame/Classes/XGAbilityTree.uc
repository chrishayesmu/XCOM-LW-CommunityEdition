class XGAbilityTree extends Actor
	native(Core)
DependsOn(XGAbility_Targeted);
//complete stub

var int m_iCurrentCategory;
var array<TAbility> m_arrAbilities;
var bool m_bInitialized;
var const localized string AbilityNames[255];
var const localized string HelpMessages[255];
var const localized string TargetMessages[255];
var const localized string PerformerMessages[255];
var const localized string AbilityAvailableMessages[255];
var const localized string AbilityDryReload;
var const localized string ShotDamageCoverTargetAbility;
var const localized string AbilityEffectRevealed;
var const localized string AbilitySentinelFlyover;

simulated function Init(){}
native simulated function InitInstanceDataFromTemplate(int iAbility, XGAbility kAbility);
simulated function TAbility GetTAbility(int iAbility){}
simulated function BuildAbilities(){}
simulated function int GetAssociatedAbilityFromPerk(int iPerk){}
native simulated function BuildTargetStatsEffect(XGAbility_Targeted kAbility);
native simulated function BuildAbilityText(XGAbility kAbility);
native simulated function bool IsAbilityAvailable(XGAbility_GameCore kAbility);
native simulated function string BuildAbilityAvailableText(XGAbility kAbility);
native function bool PerkAllowsMultipleActions(XGAbility_GameCore kAbility);
function ProcessPsiBombEffects(XGAbility_Targeted kAbility, XGUnit kTarget){}
simulated function ApplyEffectsToTarget(XGAbility_Targeted kAbility, XGUnit kTarget){}
simulated function ApplyEffectsToSelf(XGAbility_Targeted kAbility){}
function ApplyActionCost(XGAbility_Targeted kAbility){}
simulated function RemoveEffectsFromTarget(XGAbility_Targeted kAbility, out TUnitTarget kUnitTarget){}
simulated function RemoveEffectsFromSelf(XGAbility_Targeted kAbility){}
native function RegenPassivePerks(XGUnitNativeBase kUnit);
native function RegenPenaltyPerks(XGUnitNativeBase kUnit);
native function RegenBonusPerks(XGUnitNativeBase kUnit, XGAbility ContextAbility);
simulated function XComPerkManager PERKS(){}
function XGVolume CreateVolume(XGAbility_Targeted kAbility){}
simulated event GetVolume(XGAbility_Targeted kAbility, out TVolume kVolume){}
simulated function BuildAbility(EAbility eType, EAbilityTarget eTarget, int iRange, int iDuration, int iReactionCost, optional EAbilityEffect eEffect1, optional EAbilityEffect eEffect2, optional EAbilityEffect eEffect3, optional EAbilityProperty eProperty1, optional EAbilityProperty eProperty2, optional EAbilityProperty eProperty3, optional EAbilityProperty eProperty4, optional EAbilityProperty eProperty5, optional EAbilityProperty eProperty6, optional EAbilityProperty eProperty7, optional EAbilityProperty eProperty8, optional EAbilityDisplayProperty eDisplayProperty1, optional EAbilityDisplayProperty eDisplayProperty2, optional EAbilityDisplayProperty eDisplayProperty3, optional EAbilityDisplayProperty eDisplayProperty4, optional int iCooldown, optional int iCharges){}
native simulated function BuildPossibleDamage(XGAbility_Targeted kAbility);
simulated function RemoveAbilityFromBuiltAbilitiesList(XGAbility kAbility){}
simulated function ApplyAbility(XGAbility_Targeted kAbility){}
simulated function ApplyAbilityToSelf(XGAbility_Targeted kAbility){}
simulated function ApplyAbilityToTarget(XGAbility_Targeted kAbility, XGUnit kTarget){}
simulated function RemoveAbilityFromTarget(XGAbility_Targeted kAbility, out TUnitTarget kUnitTarget){}
simulated function int FindAbilityIndexOnCooldown(XGAbility_Targeted kAbility){}
native simulated function bool IsAbilityCoolingDown(XGUnitNativeBase kUnit, int iAbil);
simulated function ReduceCooldowns(XGUnit kUnit){}
simulated function RemoveAbilityFromCooldown(XGUnit kUnit, EAbility eAbil){}
simulated function RemoveAbilityFromCooldownByIndex(XGUnit kUnit, int iIndex){}
native simulated function bool IsDoubleTapAllowedAbility(int AbilityType);
simulated function RemoveAbility(XGAbility_Targeted kAbility){}
simulated function WaitForAllClientsToRemoveAbilityBeforeDestroying(XGAbility_Targeted kAbility){}
static function string GetStatImageString(int iStat, int iValue){}
simulated function XGTacticalGameCore GameCore(){}
native simulated function bool AbilityHasEffect(int iAbility, int iEffect);
native simulated function XGAbility SpawnAbility(int iAbility, XGUnitNativeBase kUnit, array<XGUnit> arrTargets, XGWeapon kWeapon, optional Actor kMiscActor, optional bool bForLocalUseOnly, optional bool bReactionFire);
native simulated function bool AbilityHasProperty(int iAbility, int iProperty);
native simulated function bool HasAutopsyTechForChar(int iCharType);

