class Highlander_UIStrategyHUD_FSM_Science extends UIStrategyHUD_FSM_Science;

simulated function XGResearchUI GetMgr(optional int iStartView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGResearchUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGResearchUI', (self), iStartView));
    }

    return m_kLocalMgr;
}

simulated function OnDeactivate()
{
    super.OnDeactivate();
    m_kLocalMgr = none;
    `HQPRES.GetStrategyHUD().ClearFacilityPanels();
    XComHQPresentationLayer(controllerRef.m_Pres).RemoveMgr(class'Highlander_XGResearchUI');
}