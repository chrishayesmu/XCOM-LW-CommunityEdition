class LWCEAbilityCharges extends Object;

struct LWCE_TBonusCharge
{
	var name AbilityName;
	var int NumCharges;
};

var int InitialCharges;

var array<LWCE_TBonusCharge> BonusCharges;