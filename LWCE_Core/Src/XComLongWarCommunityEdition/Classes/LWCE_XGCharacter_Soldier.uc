class LWCE_XGCharacter_Soldier extends XGCharacter_Soldier implements(LWCE_XGCharacter);

`include(generators_xgcharacter_fields.uci)

var LWCE_TSoldier m_kCESoldier;

`define NO_SOLDIER_FUNCS
`include(generators_xgcharacter_functions.uci)
`undefine(NO_SOLDIER_FUNCS)

function AddKills(int iNumKills)
{
    `LWCE_LOG_CLS("AddKills: iNumKills = " $ iNumKills);

    m_kCESoldier.iNumKills += iNumKills;

    if (m_kCESoldier.bBlueshirt)
    {
        XGBattle_SP(`BATTLE).AddBlueshirtKills(iNumKills);
    }
}

function AddXP(int iXP)
{
    `LWCE_LOG_CLS("AddXP: iXP = " $ iXP);

    if (CanGainXP())
    {
        if (`GAMECORE.IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
        {
            iXP /= `GAMECORE.SW_MARATHON;
        }

        if (HasItemInInventory('Item_CognitiveEnhancer'))
        {
            iXP *= 1.20;
        }

        m_kCESoldier.iXP += iXP;
    }
}

function int GetXP()
{
    return m_kCESoldier.iXP;
}

function SetXP(int iXP)
{
    `LWCE_LOG_CLS("SetXP: iXP = " $ iXP);

    if (CanGainXP())
    {
        m_kCESoldier.iXP = iXP;
    }
}

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

function bool LeveledUp()
{
    if (CanGainXP())
    {
        return m_kCESoldier.iXP >= `GAMECORE.GetXPRequired(m_kCESoldier.iRank + 1);
    }
    else
    {
        return false;
    }
}

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComMaleLevelIMedium'
}