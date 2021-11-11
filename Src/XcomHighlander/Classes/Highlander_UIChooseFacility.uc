class Highlander_UIChooseFacility extends UIChooseFacility;

simulated function XGBuildUI GetMgr()
{
    return XGBuildUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGBuildUI', (self), 1));
}