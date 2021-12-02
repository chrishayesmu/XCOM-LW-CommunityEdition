class Highlander_UISoldierSummary extends UISoldierSummary;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager, optional int iView = 0, optional bool bCovertOperativeMode = false)
{
    local XGSoldierUI kMgr;

    BaseInit(_controllerRef, _manager);

    m_kSoldier = kSoldier;

    kMgr = Spawn(class'Highlander_XGSoldierUI', XComHQPresentationLayer(controllerRef.m_Pres));
    kMgr.m_kInterface = self;
    kMgr.m_kSoldier = kSoldier;
    kMgr.m_bCovertOperativeMode = bCovertOperativeMode;
    XComHQPresentationLayer(controllerRef.m_Pres).AddPreformedMgr(kMgr);

    kMgr.Init(iView);

    m_kSoldierHeader = Spawn(class'UIStrategyComponent_SoldierInfo', self);
    m_kSoldierHeader.Init(_controllerRef, _manager, self, m_kSoldier);

    m_kSoldierStats = Spawn(class'UIStrategyComponent_SoldierStats', self);
    m_kSoldierStats.Init(GetMgr(), _controllerRef, _manager, self);

    m_kAbilityList = Spawn(class'UIStrategyComponent_SoldierAbilityList', self);
    m_kAbilityList.Init(GetMgr(), _controllerRef, _manager, self);

    manager.LoadScreen(self);
}

simulated function XGSoldierUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGSoldierUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGSoldierUI', self, iStaringView));
    }

    return m_kLocalMgr;
}