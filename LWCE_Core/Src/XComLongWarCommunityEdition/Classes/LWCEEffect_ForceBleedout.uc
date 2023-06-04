class LWCEEffect_ForceBleedout extends LWCEEffect_Persistent;

var int iNumProcsPerMission;

function bool ForceBleedout(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kBreakdown)
{
    // TODO: need somewhere on the unit to track how many times this has proc'd for the given unit

    return true;
}

defaultproperties
{
    iNumProcsPerMission=1
}