class LWCEAbilityTemplate extends LWCEDataTemplate
    config(LWCEAbilities);

enum EAbilityHostility
{
	eHostility_Offensive,
	eHostility_Defensive,
	eHostility_Neutral,
	eHostility_Movement,
};

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

var string AbilityIcon;

var const localized string strFriendlyName;
var const localized string strHelp;
var const localized string strPerformerMessage;
var const localized string strTargetMessage;

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
		nmAvailableCode = kCondition.MeetsCondition(kSourceUnit, kTarget.kPrimaryTarget);

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