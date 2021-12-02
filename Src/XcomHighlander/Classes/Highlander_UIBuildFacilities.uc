class Highlander_UIBuildFacilities extends UIBuildFacilities;

simulated function XGBuildUI GetMgr()
{
    m_kLocalMgr = XGBuildUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGBuildUI', self, 0));
    return m_kLocalMgr;
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'Highlander_XGBuildUI');
    super(UI_FxsScreen).Destroyed();
}