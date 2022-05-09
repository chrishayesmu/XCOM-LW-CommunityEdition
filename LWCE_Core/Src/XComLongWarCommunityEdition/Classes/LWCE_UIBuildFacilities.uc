class LWCE_UIBuildFacilities extends UIBuildFacilities;

simulated function XGBuildUI GetMgr()
{
    m_kLocalMgr = XGBuildUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGBuildUI', self, 0));
    return m_kLocalMgr;
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'LWCE_XGBuildUI');
    super(UI_FxsScreen).Destroyed();
}