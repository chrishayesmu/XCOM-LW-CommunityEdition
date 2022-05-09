class LWCE_UIStrategyHUD_FSM_Engineering extends UIStrategyHUD_FSM_Engineering;

simulated function XGEngineeringUI GetMgr(optional int iStartView = -1)
{
    return XGEngineeringUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGEngineeringUI', self, iStartView));
}

simulated function OnDeactivate()
{
    `HQPRES.GetStrategyHUD().m_kBuildQueue.Hide();
    super.OnDeactivate();
    XComHQPresentationLayer(controllerRef.m_Pres).RemoveMgr(class'LWCE_XGEngineeringUI');
}