class LWCE_UIChooseFacility extends UIChooseFacility;

simulated function XGBuildUI GetMgr()
{
    return XGBuildUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGBuildUI', (self), 1));
}