class LWCEEffect_Persistent extends LWCEEffect
	config(LWCEAbilities);

enum EDuplicateEffect
{
	eDupe_Allow,   // new effect is added and tracked separately from the old effect
	eDupe_Refresh, // current effect's duration is reset
	eDupe_Ignore,  // new effect is not added and old effect is unchanged
};

var int iPriority;          // Used to decide what order to iterate effects in when getting hit/crit/damage/etc modifiers. Lower
							// values are higher priority (that is, iterated before) higher values. See DefaultLWCEAbilities.ini for
							// an expanded explanation.
var int iNumTurns;
var int iInitialShedChance; // The initial chance for this effect to automatically be removed on tick.
var int iPerTickShedChance; // Each time the effect ticks, the chance to shed is increased by this amount. The increase
                            // occurs *after* checking for shed during the current tick.
var EDuplicateEffect DuplicateResponse;
var array<LWCEEffect> ApplyOnTick; // These non-persistent effects are applied every tick
var name EffectName;
var bool bInfiniteDuration;
var bool bTickWhenApplied;
var bool bRemoveWhenSourceDies;
var bool bRemoveWhenTargetDies;
var bool bRemoveWhenSourceDamaged;
var bool bRemoveWhenTargetDamaged;
var bool bCanTickEveryAction; // If true, this effect will tick after every target action; otherwise, it ticks at the start of the source's turn.

// These bools for display are deliberately adjacent to the ones above, so they all get packed in the same memory word

var bool bDisplayInHUD;             // If true, this effect is shown in the bottom left of the tactical HUD.
var bool bDisplayInDetails;         // If true, this effect is shown in the F1 view of the unit. When bDisplayInHUD is true, bDisplayInDetails will be forced true as well.
var EPerkBuffCategory BuffCategory; // Whether this effect is a passive, a buff, or a penalty. Colors the icon on the UI accordingly.
var string FriendlyName;            // Used in the F1 view.
var string FriendlyDescription;     // Used in the F1 view.
var string IconImage;               // Image to use for the icon; currently restricted to a limited set defined in Flash.

function float GetBaseDamageModifierAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, bool bIsHit, bool bIsCrit, LWCEEffect kAbilityEffect, float fCurrentDamage) { return 0.0f; }
function float GetBaseDamageModifierAsDefender(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, bool bIsHit, bool bIsCrit, LWCEEffect kAbilityEffect, float fCurrentDamage) { return 0.0f; }
function float GetModifiedDamageModifierAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, bool bIsHit, bool bIsCrit, LWCEEffect kAbilityEffect, float fBaseDamage, float fCurrentDamage) { return 0.0f; }
function float GetModifiedDamageModifierAsDefender(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, bool bIsHit, bool bIsCrit, LWCEEffect kAbilityEffect, float fBaseDamage, float fCurrentDamage) { return 0.0f; }
function float GetDamageReductionModifierAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, bool bIsHit, bool bIsCrit, LWCEEffect kAbilityEffect, float fDamage, float fCurrentDR) { return 0.0f; }
function float GetDamageReductionModifierAsDefender(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, bool bIsHit, bool bIsCrit, LWCEEffect kAbilityEffect, float fDamage, float fCurrentDR) { return 0.0f; }
function GetToHitModifiersAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, out LWCEAbilityUsageSummary kBreakdown) { }
function GetToHitModifiersAsDefender(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, out LWCEAbilityUsageSummary kBreakdown) { }
function bool ForceBleedout(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, const out LWCEAbilityUsageSummary kBreakdown) { return false; }
function bool PreventBleedout(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, const out LWCEAbilityUsageSummary kBreakdown) { return false; }

simulated function BuildPersistentEffect(int _iNumTurns, optional bool _bInfiniteDuration = false, optional bool _bRemoveWhenSourceDies = true)
{
	iNumTurns = bInfiniteDuration ? 1 : _iNumTurns;
	bInfiniteDuration = _bInfiniteDuration;
	bRemoveWhenSourceDies = _bRemoveWhenSourceDies;
}

simulated function SetDisplayInfo(EPerkBuffCategory BuffCat, string strName, string strDesc, string strIconLabel, optional bool DisplayInHUD = true, optional bool DisplayInDetails = true)
{
	BuffCategory = BuffCat;
	FriendlyName = strName;
	FriendlyDescription = strDesc;
	IconImage = strIconLabel;
	bDisplayInHUD = DisplayInHUD;
	bDisplayInDetails = DisplayInHUD || DisplayInDetails; // anything in the HUD should also show in the details
}

function name ApplyEffect(LWCE_XGUnit kSource, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, optional out LWCE_TAbilityResult kResult)
{
	local LWCEAppliedEffect kAppliedEffect;

	if (DuplicateResponse != eDupe_Allow)
	{
		kAppliedEffect = kTarget.FindEffect(EffectName);

		if (kAppliedEffect != none)
		{
			if (DuplicateResponse == eDupe_Ignore)
			{
				return 'AA_DuplicateEffectIgnored';
			}
			else
			{
				kAppliedEffect.RefreshEffect();
				return 'AA_EffectRefreshed';
			}
		}
	}

	kAppliedEffect = new (kTarget) class'LWCEAppliedEffect';
	kAppliedEffect.Init(self, kAbility, kSource, kTarget);

	kTarget.AddPersistentEffect(kAppliedEffect);

	return 'AA_Success';
}

defaultproperties
{
	DuplicateResponse=eDupe_Allow
}