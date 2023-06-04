class LWCE_UIUnitGermanMode extends UIUnitGermanMode;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, XGUnit theUnit)
{
    `LWCE_LOG_CLS("Init");

    BaseInit(_controllerRef, _manager);
    m_kUnit = theUnit;

    m_kPerks = Spawn(class'LWCE_UIUnitGermanMode_PerkList', self);
    m_kPerks.s_name = name("body.perks");
    m_kPerks.Init(controllerRef, manager, self);
    m_kPerks.PrepareData(ePerkBuff_Passive, m_strPassivePerkListTitle, m_kUnit.GetPassivePerkList(), theUnit);

    LWCE_UIUnitGermanMode_PerkList(m_kPerks).LWCE_PrepareItemData(m_kUnit.GetInventory());

    m_kBonuses = Spawn(class'LWCE_UIUnitGermanMode_PerkList', self);
    m_kBonuses.s_name = name("body.bonuses");
    m_kBonuses.Init(controllerRef, manager, self);
    m_kBonuses.PrepareData(ePerkBuff_Bonus, m_strBonusesListTitle, m_kUnit.GetBonusesPerkList(), theUnit);

    m_kPenalties = Spawn(class'LWCE_UIUnitGermanMode_PerkList', self);
    m_kPenalties.s_name = name("body.penalties");
    m_kPenalties.Init(controllerRef, manager, self);
    m_kPenalties.PrepareData(ePerkBuff_Penalty, m_strPenaltiesListTitle, m_kUnit.GetPenaltiesPerkList(), theUnit);

    m_kInfoPanel = Spawn(class'LWCE_UIUnitGermanMode_ShotInfo', self);
    m_kInfoPanel.Init(controllerRef, manager, self);
}

simulated function OnInit()
{
    super(UI_FxsScreen).OnInit();
    LWCE_UpdateHeader();
    AS_SetButtonHelp(m_strCloseGermanModeLabel, class'UI_FxsGamepadIcons'.static.GetBackButtonIcon());
}

protected simulated function LWCE_UpdateHeader()
{
    local LWCE_XGCharacter_Soldier kCharacterSoldier;
    local LWCE_XGCharacter kChar;
    local bool bIsShiv;
    local int iRank;

    kChar = LWCE_XGCharacter(m_kUnit.GetCharacter());

    if (m_kUnit.isHuman() || m_kUnit.IsShiv())
    {
        if (kChar.GetCharacterType() == eChar_Civilian)
        {
            if (m_kUnit.SafeGetCharacterFullName() != "")
            {
                AS_SetSoldierInformation(m_kUnit.SafeGetCharacterFullName(), m_kUnit.SafeGetCharacterNickname(), "", "", false);
            }
            else
            {
                AS_SetSoldierInformation(m_kUnit.SafeGetCharacterName(), m_strCivilianNickname, "", "", false);
            }

            AS_SetUnitAllegiance(false);
        }
        else
        {
            kCharacterSoldier = LWCE_XGCharacter_Soldier(kChar);

            if (m_kUnit.IsATank())
            {
                iRank = m_kUnit.GetSHIVRank();
                bIsShiv = true;
            }
            else
            {
                iRank = kCharacterSoldier.m_kCESoldier.iRank;
                bIsShiv = false;
            }

            // TODO get class label from new source
            AS_SetSoldierInformation(m_kUnit.SafeGetCharacterFullName(), m_kUnit.SafeGetCharacterNickname(), kCharacterSoldier.m_kCESoldier.strClassIcon, Class'UIUtilities'.static.GetRankLabel(iRank, bIsShiv), kCharacterSoldier.LeveledUp());
        }

        AS_SetUnitStats(m_strHealthLabel @ Max(m_kUnit.GetUnitMaxHP(), m_kUnit.m_aCurrentStats[eStat_HP]), m_strWillLabel @ GetWillBonus(m_kUnit), m_strOffenseLabel @ m_kUnit.GetOffense(), m_strDefenseLabel @ GetDefenseBonus(m_kUnit));
        AS_SetUnitAllegiance(false);
    }
    else
    {
        AS_SetAlienInformation(class'UIUtilities'.static.GetHTMLColoredText(m_kUnit.SafeGetCharacterName(), eUIState_Bad), false, m_kUnit.IsExalt());
        AS_SetUnitAllegiance(true);
    }
}