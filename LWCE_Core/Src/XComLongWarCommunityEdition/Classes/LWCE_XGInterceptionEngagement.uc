class LWCE_XGInterceptionEngagement extends XGInterceptionEngagement;

var array<name> m_arrCEConsumablesUsed;
var array<LWCE_TItemQuantity> m_arrCEConsumableQuantitiesInEffect;

function bool CanUseConsumable(int ItemName)
{
    `LWCE_LOG_DEPRECATED_CLS(CanUseConsumable);

    return false;
}

function bool LWCE_CanUseConsumable(name ItemName)
{
    if (!LWCE_IsConsumableAvailable(ItemName))
    {
        return false;
    }

    if (ItemName == 'Item_UplinkTargeting')
    {
        if (GetShip(1).m_kTShip.iRange == 2) // Defensive
        {
            return false;
        }
    }

    if (ItemName == 'Item_DefenseMatrix')
    {
        if (GetShip(1).m_kTShip.iRange == 1) // Aggressive
        {
            return false;
        }
    }

    return !LWCE_HasConsumableBeenUsed(ItemName);
}

function int GetNumConsumableInEffect(int ItemName)
{
    `LWCE_LOG_DEPRECATED_CLS(GetNumConsumableInEffect);

    return -1;
}

function int LWCE_GetNumConsumableInEffect(name ItemName)
{
    if (!LWCE_IsConsumable(ItemName))
    {
        return -1;
    }

    return `LWCE_UTILS.GetItemQuantity(m_arrCEConsumableQuantitiesInEffect, ItemName).iQuantity;
}

function bool HasConsumableBeenUsed(int ItemName)
{
    `LWCE_LOG_DEPRECATED_CLS(HasConsumableBeenUsed);

    return false;
}

function bool LWCE_HasConsumableBeenUsed(name ItemName)
{
    local int I;

    for (I = 0; I < m_arrCEConsumablesUsed.Length; I++)
    {
        if (m_arrCEConsumablesUsed[I] == ItemName)
        {
            return true;
        }
    }

    return false;
}

function bool IsConsumable(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(IsConsumable);

    return false;
}

function bool LWCE_IsConsumable(name ItemName)
{
    // TODO move to template
    if (ItemName == 'Item_DefenseMatrix' || ItemName == 'Item_UplinkTargeting' || ItemName == 'Item_UFOTracking')
    {
        return true;
    }

    return false;
}

function bool IsConsumableAvailable(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(IsConsumableAvailable);

    return false;
}

function bool LWCE_IsConsumableAvailable(name ItemName)
{
    if (!LWCE_IsConsumable(ItemName))
    {
        return false;
    }

    return LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable(ItemName) > 0;
}

function bool IsConsumableInEffect(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(IsConsumableInEffect);

    return false;
}

function bool LWCE_IsConsumableInEffect(name ItemName)
{
    return LWCE_GetNumConsumableInEffect(ItemName) > 0;
}

function bool IsConsumableResearched(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(IsConsumableResearched);

    return false;
}

function bool LWCE_IsConsumableResearched(name ItemName)
{
    local LWCEItemTemplate kItem;

    if (LWCE_IsConsumable(ItemName))
    {
        if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_AircraftBoosters'))
        {
            kItem = `LWCE_ITEM(ItemName);

            return `LWCE_HQ.ArePrereqsFulfilled(kItem.kPrereqs);
        }
    }

    return false;
}

function UseConsumable(int iItemType, float fPlaybackTime)
{
    `LWCE_LOG_DEPRECATED_CLS(UseConsumable);
}

function LWCE_UseConsumable(name ItemName, float fPlaybackTime)
{
    local int iNumUses;

    if (!LWCE_CanUseConsumable(ItemName))
    {
        return;
    }

    if (ItemName == 'Item_UFOTracking')
    {
        iNumUses = 1;
        PRES().UINarrative(`XComNarrativeMoment("RoboUFOTracking"));
        STAT_AddStat(eRecap_TrackConsumablesUsed, 1);
    }
    else if (ItemName == 'Item_DefenseMatrix')
    {
        iNumUses = 2;
        PRES().UINarrative(`XComNarrativeMoment("RoboDefenseMatrix"));
        STAT_AddStat(eRecap_DodgeConsumablesUsed, 1);
    }
    else if (ItemName == 'Item_UplinkTargeting')
    {
        iNumUses = 2;
        PRES().UINarrative(`XComNarrativeMoment("RoboSatelliteAssistAim"));
        STAT_AddStat(eRecap_AimConsumablesUsed, 1);
    }

    `LWCE_UTILS.AdjustItemQuantity(m_arrCEConsumableQuantitiesInEffect, ItemName, iNumUses);
    m_arrCEConsumablesUsed.AddItem(ItemName);
    LWCE_XGStorage(STORAGE()).LWCE_RemoveItem(ItemName, 1);
}

function UseConsumableEffect(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(UseConsumableEffect);
}

function LWCE_UseConsumableEffect(name ItemName)
{
    `LWCE_UTILS.AdjustItemQuantity(m_arrCEConsumableQuantitiesInEffect, ItemName, -1);
}