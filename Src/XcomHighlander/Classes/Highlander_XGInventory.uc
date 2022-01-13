class Highlander_XGInventory extends XGInventory;

simulated function DetermineEngagementRange()
{
    local float fRange;
    local int I;
    local XGWeapon kWeapon;

    m_fModifiableEngagementRange = 0.0;
    m_fFixedEngagementRange = 0.0;
    m_fGrenadeEngagementRange = 0.0;

    for (I = 0; I < eSlot_MAX; I++)
    {
        kWeapon = XGWeapon(GetItem(ELocation(I)));

        if (kWeapon != none && kWeapon.GetRemainingAmmo() > 0 && !kWeapon.IsOverheated())
        {
            if (kWeapon == GetActiveWeapon() || !kWeapon.CanBeStartingWeapon())
            {
                fRange = class'Highlander_XGWeapon_Extensions'.static.LongRange(kWeapon);

                if (kWeapon.IsGrenade())
                {
                    if (fRange > m_fGrenadeEngagementRange)
                    {
                        m_fGrenadeEngagementRange = fRange;
                    }
                }
                else if (kWeapon.bIsFixedRange)
                {
                    if (fRange > m_fFixedEngagementRange)
                    {
                        m_fFixedEngagementRange = fRange;
                    }
                }
                else if (fRange > m_fModifiableEngagementRange)
                {
                    m_fModifiableEngagementRange = fRange;
                }
            }
        }
    }
}

simulated function int GetNumItems(EItemType eItem)
{
    // Since this is forwards-compatible, no need to deprecate the base function
    return HL_GetNumItems(eItem);
}

simulated function int HL_GetNumItems(int iItemId)
{
    local int I, J, Num;
    local ELocation eLoc;

    for (I = 0; I < eSlot_MAX; I++)
    {
        eLoc = ELocation(I);

        for (J = 0; J < GetNumberOfItemsInSlot(eLoc); J++)
        {
            if (GetItemByIndexInSlot(J, eLoc) != none && GetItemByIndexInSlot(J, eLoc).GameplayType() == iItemId)
            {
                ++Num;
            }
        }
    }

    return Num;
}

simulated function bool HasItemOfType(EItemType anItemType)
{
    // Since this is forwards-compatible, no need to deprecate the base function
    return HL_HasItemOfType(anItemType);
}

simulated function bool HL_HasItemOfType(int iItemId)
{
    // TODO: needs extra testing, not clear if this native function will work properly with modded items
    return FindItemByEnum(iItemId) != none;
}

simulated function XGInventoryItem SearchForItemByEnumInSlot(ELocation Slot, EItemType eCompareType, optional out int iSearchIndex)
{
    `HL_LOG_DEPRECATED_NOREPLACE_CLS(SearchForItemByEnumInSlot);
    return super.SearchForItemByEnumInSlot(Slot, eCompareType, iSearchIndex);
}