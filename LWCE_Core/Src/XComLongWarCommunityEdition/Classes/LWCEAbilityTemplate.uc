class LWCEAbilityTemplate extends LWCEDataTemplate
    config(LWCEAbilities);

enum EAbilityHostility
{
	eHostility_Offensive,
	eHostility_Defensive,
	eHostility_Neutral,
	eHostility_Movement
};

enum EAbilityHitResult
{
	eHit_HitNoCrit,
	eHit_HitCrit,
	eHit_Miss,
	eHit_Prevented,
	eHit_Reflect
};

enum EAbilityWeaponSlot
{
	eAWS_Primary,   // Always use the weapon in the primary equip slot
	eAWS_Secondary, // Always use the weapon in the secondary equip slot
	eAWS_Equipped,  // Use whichever weapon the unit has active
	eAWS_Source,    // Use whichever weapon is the source of the ability
	eAWS_None       // No weapon should be associated with the ability
};

struct LWCE_TEffectResults
{
	var array<LWCEEffect> Effects;
	var array<name> ApplyResults;
};

struct LWCE_TAbilityInputContext
{
    var name AbilityTemplateName;       // The name of the ability's template
    var LWCE_XGAbility Ability;         // Instance of the ability being used

    var Actor PrimaryTarget;            // The main target of the ability; may be none
    var array<Actor> AdditionalTargets; // Additional targets of the ability, if any
    var array<Vector> TargetLocations;  // If one or more locations is being targeted, they will be here

    var Actor Source;         // The source of the ability
    var LWCE_XGWeapon Weapon; // The weapon/item this ability was used with, if any
};

struct LWCE_TAbilityResult
{
    var EAbilityHitResult HitResult;
	var LWCE_TEffectResults SourceEffectResults;
	var LWCE_TEffectResults TargetEffectResults;
};

struct LWCE_TDamagePreview
{
    var LWCE_XGUnit kPrimaryTarget; // The main target of the ability; can be none.
    var int iMaxDamage; // Max damage that this ability could roll. Should already include mitigation by DR.
    var int iMinDamage; // Min damage that this ability could roll. Should already include mitigation by DR.
    var int iMaxDamageReduction; // Damage reduction that will apply if the max damage is rolled.
    var int iMinDamageReduction; // Damage reduction that will apply if the min damage is rolled.
};

var EAbilityHostility Hostility;
var EAbilityWeaponSlot UseWithWeaponSlot;

var LWCEAbilityCharges AbilityCharges;
var array<LWCEAbilityCost> AbilityCosts;
var LWCEAbilityCooldown AbilityCooldown;
var array<LWCEEffect> AbilitySourceEffects;
var array<LWCEEffect> AbilityTargetEffects;
var array<LWCEAbilityTrigger> AbilityTriggers; // Ability will activate automatically in response to any of these triggers
var LWCEAbilityToHitCalc AbilityToHitCalc;
var array<LWCECondition> AbilityShooterConditions;
var array<LWCECondition> AbilityTargetConditions;
var LWCEAbilityTargetStyle AbilityTargetStyle;

var delegate<BuildVisualizationDelegate> BuildVisualizationFn;

var string AbilityIcon;

var const localized string strFriendlyName;
var const localized string strHelp; // Short help message for activated abilities in the shot HUD
var const localized string strDescription; // Longer description of the ability, shown in the tactical details HUD (F1)
var const localized string strPerformerMessage;
var const localized string strTargetMessage;

delegate BuildVisualizationDelegate(const out LWCE_TAbilityInputContext kInputContext, const out LWCE_TAbilityResult kResult);

function name GetAbilityName()
{
	return DataName;
}

function name CanAfford(LWCE_XGAbility kAbility, const LWCE_TAvailableTarget kTarget)
{
	local LWCEAbilityCost kCost;
	local name nmAvailableCode;

`if(`notdefined(FINAL_RELEASE))
	if (kAbility.m_TemplateName != GetAbilityName())
	{
		`LWCE_LOG_CLS("ERROR: template name " $ GetAbilityName() $ " was called for an LWCE_XGAbility which uses the template name " $ kAbility.m_TemplateName);
		return 'AA_InvalidArgument';
	}
`endif

	foreach AbilityCosts(kCost)
	{
		nmAvailableCode = kCost.CanAfford(kAbility, kTarget);

		if (nmAvailableCode != 'AA_Success')
		{
			return nmAvailableCode;
		}
	}

    return 'AA_Success';
}

function name CheckAvailable(LWCE_XGAbility kAbility, const LWCE_TAvailableTarget kTarget)
{
	local LWCE_XGUnit kSourceUnit;
	local LWCEAbilityCost kCost;
	local LWCECondition kCondition;
	local name nmAvailableCode;

	kSourceUnit = LWCE_XGUnit(kAbility.m_kUnit);

	foreach AbilityShooterConditions(kCondition)
	{
		nmAvailableCode = kCondition.MeetsCondition(kSourceUnit, none);

		if (nmAvailableCode != 'AA_Success')
		{
			return nmAvailableCode;
		}
	}

	foreach AbilityTargetConditions(kCondition)
	{
		nmAvailableCode = kCondition.MeetsCondition(kSourceUnit, kTarget.kPrimaryTarget);

		if (nmAvailableCode != 'AA_Success')
		{
			return nmAvailableCode;
		}
	}

	foreach AbilityCosts(kCost)
	{
		nmAvailableCode = kCost.CanAfford(kAbility, kTarget);

		if (nmAvailableCode != 'AA_Success')
		{
			return nmAvailableCode;
		}
	}

	// TODO check cooldown

	return 'AA_Success';
}

function GatherTargets(const LWCE_XGAbility kAbility, out array<LWCE_TAvailableTarget> arrTargets)
{
	local LWCE_XGUnit kSourceUnit;
	local int iCondition, iTarget, iAdditionalTarget;

	kSourceUnit = LWCE_XGUnit(kAbility.m_kUnit);

	AbilityTargetStyle.GatherTargets(kAbility, arrTargets);

	for (iCondition = 0; iCondition < AbilityTargetConditions.Length; iCondition++)
	{
		for (iTarget = arrTargets.Length - 1; iTarget >= 0; iTarget--)
		{
			if (arrTargets[iTarget].kPrimaryTarget != none && AbilityTargetConditions[iCondition].MeetsCondition(kSourceUnit, arrTargets[iTarget].kPrimaryTarget) != 'AA_Success')
			{
				arrTargets.Remove(iTarget, 1);
				continue;
			}

			for (iAdditionalTarget = arrTargets[iTarget].arrAdditionalTargets.Length - 1; iAdditionalTarget >= 0; iAdditionalTarget--)
			{
				if (AbilityTargetConditions[iCondition].MeetsCondition(kSourceUnit, arrTargets[iTarget].arrAdditionalTargets[iAdditionalTarget]) != 'AA_Success')
				{
					arrTargets[iTarget].arrAdditionalTargets.Remove(iAdditionalTarget, 1);
				}
			}

			if (arrTargets[iTarget].kPrimaryTarget == none && arrTargets[iTarget].arrAdditionalTargets.Length == 0)
			{
				arrTargets.Remove(iTarget, 1);
				continue;
			}
		}
	}
}

function LWCEAbilityUsageSummary GenerateAbilityPreview(LWCE_XGAbility kAbility, LWCE_TAvailableTarget kTarget)
{
	local LWCEAbilityUsageSummary kBreakdown;

	kBreakdown = new class'LWCEAbilityUsageSummary';

	AbilityToHitCalc.ApplyToAbilityBreakdown(kAbility, kTarget, kBreakdown);

	return kBreakdown;
}

function bool IsAbilityInputTriggered()
{
	local LWCEAbilityTrigger kTrigger;

	foreach AbilityTriggers(kTrigger)
	{
		if (kTrigger.IsA('LWCEAbilityTrigger_PlayerInput'))
		{
			return true;
		}
	}

	return false;
}

function bool IsTriggeredOnUnitPostBeginPlay()
{
	local LWCEAbilityTrigger kTrigger;

	foreach AbilityTriggers(kTrigger)
	{
		if (kTrigger.IsA('LWCEAbilityTrigger_UnitPostBeginPlay'))
		{
			return true;
		}
	}

	return false;
}

/// <summary>
/// Whether this ability should enable inverse kinematics for the unit's left hand. Typically this is false for
/// grenade abilities and psionics, and true for all other abilities.
/// </summary>
function bool UseLeftHandIK()
{
	// TODO implement
	return true;
}

defaultproperties
{
	Hostility=eHostility_Offensive
	UseWithWeaponSlot=eAWS_None
}