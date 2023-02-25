class LWCEAbilityTemplate extends LWCEDataTemplate;

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
var LWCEAbilityToHitCalc AbilityToHitCalc;
var array<LWCEAbilityCondition> AbilityShooterConditions;
var array<LWCEAbilityCondition> AbilityTargetConditions;
var LWCEAbilityTargetStyle AbilityTargetStyle;

function name GetAbilityName()
{
	return DataName;
}

simulated function name CanAfford(LWCE_XGAbility kAbility)
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
		nmAvailableCode = kCost.CanAfford(kAbility);

		if (nmAvailableCode != 'AA_Success')
		{
			return nmAvailableCode;
		}
	}

    return 'AA_Success';
}