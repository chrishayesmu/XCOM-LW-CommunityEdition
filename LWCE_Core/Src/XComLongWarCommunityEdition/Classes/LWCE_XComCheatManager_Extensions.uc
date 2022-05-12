class LWCE_XComCheatManager_Extensions extends Object
    abstract;

/// <summary>
/// Finds a perk by the given string. Depending on the string, there are two ways this
/// function can operate.
///
/// 1. If the string can be converted to an integer, then a perk is looked for with perk ID
///    equal to that integer.
/// 2. Otherwise, the string is assumed to be the normalized name of a perk, as returned
///    by the NormalizeString function in this class. A perk with the corresponding normalized
///    name will be looked for. This is case-insensitive.
///
/// In either case, if the target perk is found, its ID is returned. Otherwise, -1 is returned.
/// </summary>
static function int FindPerkByString(string strPerk, LWCE_XComPerkManager kPerksMgr)
{
    local int Index, iPerkId;
    local string strPerkName;
    local LWCE_TPerk kPerk;

    iPerkId = int(strPerk);

    if (iPerkId != 0)
    {
        kPerk = kPerksMgr.LWCE_GetPerk(iPerkId);

        if (kPerk.iPerkId != 0)
        {
            return kPerk.iPerkId;
        }
        else
        {
            return -1;
        }
    }

    for (Index = 0; Index < kPerksMgr.m_arrCEPerks.Length; Index++)
    {
        strPerkName = kPerksMgr.GetPerkName(kPerksMgr.m_arrCEPerks[Index].iPerkId);
        strPerkName = NormalizeString(strPerkName);

        if (strPerkName ~= strPerk)
        {
            return kPerksMgr.m_arrCEPerks[Index].iPerkId;
        }
    }

    return -1;
}

static function string NormalizeString(string InString)
{
    InString = Repl(InString, " ", "");
    InString = Repl(InString, ":", "");
    InString = Repl(InString, "-", "");
    InString = Repl(InString, "'", "");

    return InString;
}