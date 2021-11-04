class Highlander_UIChooseTech extends UIChooseTech;

simulated function XGResearchUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGResearchUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGResearchUI', (self), m_iView));
    }

    return m_kLocalMgr;
}