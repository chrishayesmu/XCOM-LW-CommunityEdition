class LWCE_UIStrategyComponent_SoldierAbilityList extends UIStrategyComponent_SoldierAbilityList;

function UpdateData()
{
    local int I, Length;
    local LWCE_TPerk kPerk;
    local TTableMenuOption kTableOption;
    local LWCE_XComPerkManager kPerkMgr;

    kPerkMgr = LWCE_XComPerkManager(m_KLocalMgr.perkMgr());

    if (m_iAddedAbilities > 0)
    {
        ClearAbilityList();
    }

    Length = m_kLocalMgr.m_kAbilities.tblAbilities.arrOptions.Length;

    if (Length > 0)
    {
        AS_SetTitle(m_strAbilitiesTitle);
    }

    for (I = 0; I < Length; I++)
    {
        kTableOption = m_kLocalMgr.m_kAbilities.tblAbilities.arrOptions[I];
        kPerk = kPerkMgr.LWCE_GetPerk(kTableOption.arrStates[0]);
        AS_AddAbility(kPerk.strPassiveTitle, kPerk.Icon, false);
    }

    m_iAddedAbilities = Length;
}