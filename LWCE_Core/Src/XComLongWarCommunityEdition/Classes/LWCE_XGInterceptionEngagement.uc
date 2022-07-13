class LWCE_XGInterceptionEngagement extends XGInterceptionEngagement;

function bool IsConsumableResearched(int iItemType)
{
    local LWCE_TItem kItem;

    if (IsConsumable(iItemType))
    {
        if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_AircraftBoosters'))
        {
            kItem = `LWCE_ITEM(iItemType);

            return `LWCE_HQ.ArePrereqsFulfilled(kItem.kPrereqs);
        }
    }

    return false;
}

function UseConsumable(int iItemType, float fPlaybackTime)
{
    if (!CanUseConsumable(iItemType))
    {
        return;
    }

    if (iItemType == `LW_ITEM_ID(UFOTrackingBoost))
    {
        m_aiConsumableQuantitiesInEffect[1] += 1;
        PRES().UINarrative(`XComNarrativeMoment("RoboUFOTracking"));
        STAT_AddStat(eRecap_TrackConsumablesUsed, 1);
    }
    else if (iItemType == `LW_ITEM_ID(DefenseMatrixDodge))
    {
        m_aiConsumableQuantitiesInEffect[0] += 2;
        PRES().UINarrative(`XComNarrativeMoment("RoboDefenseMatrix"));
        STAT_AddStat(eRecap_DodgeConsumablesUsed, 1);
    }
    else if (iItemType == `LW_ITEM_ID(UplinkTargetingAim))
    {
        m_aiConsumableQuantitiesInEffect[2] += 2;
        PRES().UINarrative(`XComNarrativeMoment("RoboSatelliteAssistAim"));
        STAT_AddStat(eRecap_AimConsumablesUsed, 1);
    }

    m_aiConsumablesUsed.AddItem(iItemType);
    STORAGE().RemoveItem(iItemType, 1);
}