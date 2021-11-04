class Highlander_UIStrategyHUD_BuildQueue extends UIStrategyHUD_BuildQueue;

simulated function XGEngineeringUI GetMgr(optional IScreenMgrInterface kInterface = none)
{
    return XGEngineeringUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGEngineeringUI', kInterface));
}