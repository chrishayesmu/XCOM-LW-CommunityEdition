class LWCEUtils extends Object
    dependson(LWCETypes);

static function bool AreVectorsSame(const Vector2D v1, const Vector2D v2, optional float fTolerance = 1.0f)
{
    return Abs(v1.x - v2.x) <= fTolerance && Abs(v1.y - v2.y) <= fTolerance;
}

static function AdjustItemQuantity(out array<LWCE_TItemQuantity> arrItemQuantities, name ItemName, int iQuantity, optional bool bDeleteIfAllRemoved = true)
{
    local int Index;
    local LWCE_TItemQuantity kItemQuantity;

    Index = arrItemQuantities.Find('ItemName', ItemName);

    if (Index == INDEX_NONE)
    {
        if (iQuantity > 0)
        {
            kItemQuantity.ItemName = ItemName;
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

static function LWCE_TItemQuantity GetItemQuantity(out array<LWCE_TItemQuantity> arrItemQuantities, name ItemName, optional out int Index)
{
    local LWCE_TItemQuantity kItemQuantity;

    Index = arrItemQuantities.Find('ItemName', ItemName);

    if (Index == INDEX_NONE)
    {
        kItemQuantity.ItemName = ItemName;
        kItemQuantity.iQuantity = 0;

        return kItemQuantity;
    }

    return arrItemQuantities[Index];
}

static function string GetResearchCreditFriendlyName(name CreditName)
{
    local int iLocIndex;

    switch (CreditName)
    {
        case 'Aerospace':
            iLocIndex = 4;
            break;
        case 'All':
            iLocIndex = 9;
            break;
        case 'AllArmor':
            iLocIndex = 5;
            break;
        case 'AllWeapons':
            iLocIndex = 3;
            break;
        case 'Cybernetics':
            iLocIndex = 6;
            break;
        case 'GaussWeapons':
            iLocIndex = 7;
            break;
        case 'LaserWeapons':
            iLocIndex = 1;
            break;
        case 'PlasmaWeapons':
            iLocIndex = 2;
            break;
        case 'Psionics':
            iLocIndex = 8;
            break;
        default:
            iLocIndex = -1;
            break;
    }

    if (iLocIndex < 0)
    {
        return "";
    }

    return class'XGLocalizedData'.default.ResearchCreditNames[iLocIndex];
}

/// <summary>
/// Retrieves a character stat by enum. All stats are returned as floats, but the integer stats can be
/// safely cast to integers without loss of data. Note that since this uses ECharacterStat, not all stats
/// can be retrieved by this method. Additionally, not all values in ECharacterStat have corresponding entries
/// in LWCE_TCharacterStats, and the ones that don't will return 0.
/// </summary>
static function float GetCharacterStat(ECharacterStat eStat, const LWCE_TCharacterStats kStats)
{
    switch (eStat)
    {
        case eStat_Offense:
            return kStats.iAim;
        case eStat_CriticalShot:
            return kStats.iCriticalChance;
        case eStat_Damage:
            return kStats.iDamage;
        case eStat_DamageReduction:
            return kStats.fDamageReduction;
        case eStat_Defense:
            return kStats.iDefense;
        case eStat_FlightFuel:
            return kStats.iFlightFuel;
        case eStat_HP:
            return kStats.iHP;
        case eStat_Mobility:
            return kStats.iMobility;
        case eStat_ShieldHP:
            return kStats.iShieldHP;
        case eStat_SightRadius:
            return kStats.iSightRadius;
        case eStat_Will:
            return kStats.iWill;
        default:
            return 0;
    }
}

/// <summary>
/// Checks if the given Foundry tech is researched in a way that works for both the tactical and strategy game.
/// This function assumes the current game is fully set up, and may throw errors if called from the initialization
/// path of either the tactical or strategy layer.
/// </summary>
static function bool IsFoundryTechResearched(name TechName)
{
    if (`LWCE_IS_TAC_GAME)
    {
        return `LWCE_TAC_CARGO.HasFoundryProject(TechName);
    }

    return `LWCE_ENGINEERING.LWCE_IsFoundryTechResearched(TechName);
}

/// <summary>
/// Opens LWCE's mod settings menu, handling checks for whichever presentation layer we're currently in.
/// </summary>
static simulated function OpenModSettingsMenu()
{
    if (`LWCE_HQPRES != none)
    {
        `LWCE_HQPRES.LWCE_UIModSettings();
    }
    else if (`LWCE_TACPRES != none)
    {
        `LWCE_TACPRES.LWCE_UIModSettings();
    }/*
    else if (`LWCE_SHELLPRES != none)
    {
        `LWCE_SHELLPRES.LWCE_UIModSettings();
    } */
    else
    {
        `LWCE_LOG_CLS("ERROR: could not find appropriate presentation layer to open mod settings menu");
    }
}

/// <summary>
/// Selects a random value from the given range.
/// </summary>
static function int RandInRange(LWCE_TRange kRange)
{
    return kRange.MinInclusive + Rand(kRange.MaxInclusive - kRange.MinInclusive + 1);
}

/// <summary>
/// Scales the given cost to be appropriate for Dynamic War. Scaling does not apply to cash, alloy,
/// elerium, or meld costs.
/// </summary>
static function ScaleCostForDynamicWar(out LWCE_TCost kCost)
{
    local int Index;

    if (kCost.iWeaponFragments > 0)
    {
        kCost.iWeaponFragments = Max(1, int(kCost.iWeaponFragments * class'XGTacticalGameCore'.default.SW_MARATHON));
    }

    for (Index = 0; Index < kCost.arrItems.Length; Index++)
    {
        kCost.arrItems[Index].iQuantity = Max(1, int(kCost.arrItems[Index].iQuantity * class'XGTacticalGameCore'.default.SW_MARATHON));
    }
}

static function SetItemQuantity(out array<LWCE_TItemQuantity> arrItemQuantities, name ItemName, int iQuantity)
{
    local int Index;
    local LWCE_TItemQuantity kItemQuantity;

    Index = arrItemQuantities.Find('ItemName', ItemName);

    if (Index == INDEX_NONE)
    {
        if (iQuantity > 0)
        {
            kItemQuantity.ItemName = ItemName;
            kItemQuantity.iQuantity = iQuantity;

            arrItemQuantities.AddItem(kItemQuantity);
        }
    }
    else
    {
        arrItemQuantities[Index].iQuantity = iQuantity;
    }
}

static function LWCE_TStaffRequirement StaffRequirement(name StaffName, int iQuantity)
{
    local LWCE_TStaffRequirement kReq;

    kReq.StaffType = StaffName;
    kReq.NumRequired = iQuantity;

    return kReq;
}

// #region Helper functions related to key-value pairs

/// <summary>
/// Looks for a key in the given data, and if found, adds iModifier to it. If not found,
/// a new pair is added to the data, and iModifier is its value.
/// </summary>
static function ModifyKeyValuePair(out array<LWCE_NameIntKVP> arrData, name nmKey, int iModifier)
{
    local LWCE_NameIntKVP kPair;
    local int Index;

    Index = arrData.Find('Key', nmKey);

    if (Index != INDEX_NONE)
    {
        arrData[Index].Value += iModifier;
    }
    else
    {
        kPair.Key = nmKey;
        kPair.Value = iModifier;
        arrData.AddItem(kPair);
    }
}

/// <summary>
/// Looks for a key in the given array and retrieves the corresponding value. If the key is
/// not found, then iValue is unmodified.
/// </summary>
/// <returns>True if the key was found, false otherwise.</returns>
static function bool TryFindValue(array<LWCE_NameIntKVP> arrData, name nmKey, out int iValue)
{
    local int Index;

    Index = arrData.Find('Key', nmKey);

    if (Index != INDEX_NONE)
    {
        iValue = arrData[Index].Value;
        return true;
    }

    return false;
}

/// <summary>
/// Updates-or-inserts a value into an array of key-value pairs. Note that if a key is present on multiple
/// entries in the array, the value will only be updated for one of those entries.
/// </summary>
static function UpsertKeyValuePair(out array<LWCE_NameIntKVP> arrData, name nmKey, int iValue)
{
    local LWCE_NameIntKVP kPair;
    local int Index;

    Index = arrData.Find('Key', nmKey);

    if (Index == INDEX_NONE)
    {
        kPair.Key = nmKey;
        kPair.Value = iValue;

        arrData.AddItem(kPair);
    }
    else
    {
        arrData[Index].Value = iValue;
    }
}

// #endregion