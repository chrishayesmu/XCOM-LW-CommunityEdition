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

/// <summary>
/// Checks if the given Foundry tech is researched in a way that works for both the tactical and strategy game.
/// This function assumes the current game is fully set up, and may throw errors if called from the initialization
/// path of either the tactical or strategy layer.
/// </summary>
static function bool IsFoundryTechResearched(int iTechId)
{
    if (`HL_IS_TAC_GAME)
    {
        return `HL_TAC_CARGO.HasFoundryTech(iTechId);
    }

    return `HL_ENGINEERING.IsFoundryTechResearched(iTechId);
}

/// <summary>
/// Selects a random value from the given range.
/// </summary>
static function int RandInRange(HL_TRange kRange)
{
    return kRange.MinInclusive + Rand(kRange.MaxInclusive - kRange.MinInclusive + 1);
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