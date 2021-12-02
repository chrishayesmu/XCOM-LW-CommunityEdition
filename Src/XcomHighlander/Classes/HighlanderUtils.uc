class HighlanderUtils extends Object
    dependson(HighlanderTypes);

static function AdjustItemQuantity(out array<HL_TItemQuantity> arrItemQuantities, int iItemId, int iQuantity, optional bool bDeleteIfAllRemoved = true)
{
    local int Index;
    local HL_TItemQuantity kItemQuantity;

    Index = arrItemQuantities.Find('iItemId', iItemId);

    if (Index == INDEX_NONE)
    {
        if (iQuantity > 0)
        {
            kItemQuantity.iItemId = iItemId;
            kItemQuantity.iQuantity = iQuantity;

            Index = arrItemQuantities.Length;
            arrItemQuantities.AddItem(kItemQuantity);
        }
    }
    else
    {
        arrItemQuantities[Index].iQuantity += iQuantity;
    }

    if (Index != INDEX_NONE && arrItemQuantities[Index].iQuantity <= 0 && bDeleteIfAllRemoved)
    {
        arrItemQuantities.Remove(Index, 1);
    }
}

static function HL_TItemQuantity GetItemQuantity(out array<HL_TItemQuantity> arrItemQuantities, int iItemId, optional out int Index)
{
    local HL_TItemQuantity kItemQuantity;

    Index = arrItemQuantities.Find('iItemId', iItemId);

    if (Index == INDEX_NONE)
    {
        kItemQuantity.iItemId = iItemId;
        kItemQuantity.iQuantity = 0;

        return kItemQuantity;
    }

    return arrItemQuantities[Index];
}

static function SetItemQuantity(out array<HL_TItemQuantity> arrItemQuantities, int iItemId, int iQuantity)
{
    local int Index;
    local HL_TItemQuantity kItemQuantity;

    Index = arrItemQuantities.Find('iItemId', iItemId);

    if (Index == INDEX_NONE)
    {
        if (iQuantity > 0)
        {
            kItemQuantity.iItemId = iItemId;
            kItemQuantity.iQuantity = iQuantity;

            arrItemQuantities.AddItem(kItemQuantity);
        }
    }
    else
    {
        arrItemQuantities[Index].iQuantity = iQuantity;
    }
}

static function int SortItemsById(HL_TItem kItem1, HL_TItem kItem2)
{
    if (kItem1.iItemId <= kItem2.iItemId)
    {
        return 0;
    }

    return -1;
}