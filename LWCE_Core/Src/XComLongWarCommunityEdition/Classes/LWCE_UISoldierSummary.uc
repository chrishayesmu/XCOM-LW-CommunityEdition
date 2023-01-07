class LWCE_UISoldierSummary extends UISoldierSummary;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager, optional int iView = 0, optional bool bCovertOperativeMode = false)
{
    local XGSoldierUI kMgr;

    BaseInit(_controllerRef, _manager);

    m_kSoldier = kSoldier;

    kMgr = Spawn(class'LWCE_XGSoldierUI', XComHQPresentationLayer(controllerRef.m_Pres));
    kMgr.m_kInterface = self;
    kMgr.m_kSoldier = kSoldier;
    kMgr.m_bCovertOperativeMode = bCovertOperativeMode;
    XComHQPresentationLayer(controllerRef.m_Pres).AddPreformedMgr(kMgr);

    kMgr.Init(iView);

    m_kSoldierHeader = Spawn(class'LWCE_UIStrategyComponent_SoldierInfo', self);
    m_kSoldierHeader.Init(_controllerRef, _manager, self, m_kSoldier);

    m_kSoldierStats = Spawn(class'LWCE_UIStrategyComponent_SoldierStats', self);
    m_kSoldierStats.Init(GetMgr(), _controllerRef, _manager, self);

    m_kAbilityList = Spawn(class'LWCE_UIStrategyComponent_SoldierAbilityList', self);
    m_kAbilityList.Init(GetMgr(), _controllerRef, _manager, self);

    manager.LoadScreen(self);
}

simulated function XGSoldierUI GetMgr(optional int iStartingView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGSoldierUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGSoldierUI', self, iStartingView));
    }

    return m_kLocalMgr;
}

simulated function OnSoldierList()
{
    Hide();
    `HQPRES.UISoldierList(class'LWCE_UISoldierList_SelectCovertOperative');
}