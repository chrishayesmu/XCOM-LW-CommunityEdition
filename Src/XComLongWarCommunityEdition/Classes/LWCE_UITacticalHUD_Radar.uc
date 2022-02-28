class LWCE_UITacticalHUD_Radar extends UITacticalHUD_Radar;

simulated function UpdateActiveUnit()
{
    if (!IsInited())
    {
        return;
    }

    m_kActiveUnit = XComTacticalController(controllerRef).GetActiveUnit();

    if (m_kActiveUnit == none)
    {
        Hide();
        return;
    }
    else if (m_kActiveUnit.GetCharacter().HasUpgrade(ePerk_GeneMod_BioelectricSkin))
    {
        Show();
    }
    else if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kActiveUnit.GetCharacter().m_kChar.kInventory, 255))
    {
        Show();
    }
    else if ( (XGUnit(m_kActiveUnit).m_iZombieMoraleLoss & -2147483648) != 0 )
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