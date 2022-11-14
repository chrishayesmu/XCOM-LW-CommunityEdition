class LWCE_XGCharacter_Soldier extends XGCharacter_Soldier implements(LWCE_XGCharacter);

`include(generators_xgcharacter_fields.uci)

var LWCE_TSoldier m_kCESoldier;

`include(generators_xgcharacter_functions.uci)

simulated function string GetName()
{
    if (m_kCEChar.iCharacterType == eChar_Tank)
    {
        return m_kCEChar.strName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(LeadByExample)) == INDEX_NONE)
    {
        return `GAMECORE.GetRankString(m_kCESoldier.iRank, true) @ m_kCESoldier.strLastName;
    }

    // TODO: all of these should be localized and somehow configurable
    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(SoOthersMayLive)) != INDEX_NONE)
    {
        return "CMDR" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(CombinedArms)) != INDEX_NONE)
    {
        return "CMDR" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(BandOfWarriors)) != INDEX_NONE)
    {
        return "COL" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(EspritDeCorps)) != INDEX_NONE)
    {
        return "COL" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(SoShallYouFight)) != INDEX_NONE)
    {
        return "MAJ" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(IntoTheBreach)) != INDEX_NONE)
    {
        return "MAJ" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(FortioresUna)) != INDEX_NONE)
    {
        return "CAPT" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(SemperVigilans)) != INDEX_NONE)
    {
        return "CAPT" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(StayFrosty)) != INDEX_NONE)
    {
        return "LT" @ m_kCESoldier.strLastName;
    }

    if (m_kCEChar.arrPerks.Find('Id', `LW_PERK_ID(LegioPatriaNostra)) != INDEX_NONE)
    {
        return "LT" @ m_kCESoldier.strLastName;
    }

    return `GAMECORE.GetRankString(m_kCESoldier.iRank, true) @ m_kCESoldier.strLastName;
}

simulated function string GetFullName()
{
    return m_kCESoldier.strFirstName @ m_kCESoldier.strLastName;
}

simulated function string GetFirstName()
{
    return m_kCESoldier.strFirstName;
}

simulated function string GetLastName()
{
    return m_kCESoldier.strLastName;
}

simulated function string GetNickname()
{
    if (m_kCESoldier.strNickName == "")
    {
        return "";
    }
    else
    {
        return "'" $ m_kCESoldier.strNickName $ "'";
    }
}

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComMaleLevelIMedium'
}