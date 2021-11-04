class Highlander_UIScienceLabs extends UIScienceLabs;

simulated function XGResearchUI GetMgr()
{
    return XGResearchUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGResearchUI', (self)));
}