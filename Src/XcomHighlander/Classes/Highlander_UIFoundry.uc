class Highlander_UIFoundry extends UIFoundry;

simulated function XGFoundryUI GetMgr()
{
    return XGFoundryUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGFoundryUI', (self), m_iView));
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'Highlander_XGFoundryUI');
    super.Destroyed();
}