class Highlander_XGInventory extends XGInventory;

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