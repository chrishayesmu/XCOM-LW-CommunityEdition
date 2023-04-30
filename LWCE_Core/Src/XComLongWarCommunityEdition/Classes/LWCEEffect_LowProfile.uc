class LWCEEffect_LowProfile extends LWCEEffect_Persistent;

// TODO: using this hook won't make the Low Profile bonus show up in a unit's defense stat in the F1 view; we need
// some sort of expanded functionality if we want to support that
function GetToHitModifiersAsDefender(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kBreakdown)
{
    local int Index, iHitChanceModifier;

    Index = kBreakdown.arrHitChanceModifiers.Find('Source', 'CoverBonus');

    if (Index == INDEX_NONE)
    {
        return;
    }

    if (kBreakdown.arrHitChanceModifiers[Index].iValue == `LWCE_TACCFG(LOW_COVER_BONUS))
    {
        `LWCE_LOG_CLS("Upgrading cover bonus from low to high");
        iHitChanceModifier = -1 * (`LWCE_TACCFG(HIGH_COVER_BONUS) - `LWCE_TACCFG(LOW_COVER_BONUS));
        kBreakdown.AddHitChanceMod(EffectName, FriendlyName, iHitChanceModifier);
    }
}

defaultproperties
{
    EffectName="LowProfile"
    DuplicateResponse=eDupe_Ignore
}