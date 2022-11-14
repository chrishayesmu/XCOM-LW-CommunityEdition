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

    m_kInfoPanel = Spawn(class'UIUnitGermanMode_ShotInfo', self);
    m_kInfoPanel.Init(controllerRef, manager, self);
}