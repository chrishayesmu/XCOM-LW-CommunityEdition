class LWCE_UITacticalHUD_Radar extends UITacticalHUD_Radar;

simulated function Show()
{
    local LWCE_XGUnit kActiveUnit;
    local TInventory kInventory;

    if (`BATTLE.m_kDesc.m_bIsTutorial)
    {
        return;
    }

    m_kActiveUnit = XComTacticalController(controllerRef).GetActiveUnit();
    kActiveUnit = LWCE_XGUnit(m_kActiveUnit);

    if (kActiveUnit == none)
    {
        Hide();
        return;
    }

    kInventory = kActiveUnit.GetTInventory();

    if (kActiveUnit.HasPerk(`LW_PERK_ID(BioelectricSkin)))
    {
        super(UI_FxsPanel).Show();
        ActivateRadarTracking();
    }
    else if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInventory, 255))
    {
        super(UI_FxsPanel).Show();
        ActivateRadarTracking();
    }
    else if ((kActiveUnit.m_iZombieMoraleLoss & -2147483648) != 0)
    {
        super(UI_FxsPanel).Show();
        ActivateRadarTracking();
    }
}

simulated function UpdateActiveUnit()
{
    local LWCE_XGUnit kActiveUnit;
    local TInventory kInventory;

    if (!IsInited())
    {
        return;
    }

    m_kActiveUnit = XComTacticalController(controllerRef).GetActiveUnit();
    kActiveUnit = LWCE_XGUnit(m_kActiveUnit);

    if (kActiveUnit == none)
    {
        Hide();
        return;
    }

    kInventory = kActiveUnit.GetTInventory();

    if (kActiveUnit.HasPerk(`LW_PERK_ID(BioelectricSkin)))
    {
        Show();
    }
    else if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInventory, 255))
    {
        Show();
    }
    else if ((kActiveUnit.m_iZombieMoraleLoss & -2147483648) != 0)
    {
        Show();
    }
    else
    {
        // Don't know why both are called here
        Show();
        Hide();
        return;
    }

    m_arrBlips.Remove(0, m_arrBlips.Length);
    UpdateBlips();
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kActiveUnit, 'm_bInCover', self, UpdateBlips);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kActiveUnit, 'Location', self, UpdateBlips);

    if (m_hEnemyArrWatchHandle != 0)
    {
        WorldInfo.MyWatchVariableMgr.UnRegisterWatchVariable(m_hEnemyArrWatchHandle);
    }

    m_hEnemyArrWatchHandle = WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kActiveUnit, 'm_arrVisibleEnemies', self, UpdateBlips);
}