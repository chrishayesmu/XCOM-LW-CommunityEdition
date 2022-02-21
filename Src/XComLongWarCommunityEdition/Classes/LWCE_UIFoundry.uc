class LWCE_UIFoundry extends UIFoundry;

simulated function XGFoundryUI GetMgr()
{
    return XGFoundryUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGFoundryUI', (self), m_iView));
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'LWCE_XGFoundryUI');
    super.Destroyed();
}