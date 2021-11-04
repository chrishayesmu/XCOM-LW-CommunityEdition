class Highlander_UIMissionControl_AlertWithMultipleButtons extends UIMissionControl_AlertWithMultipleButtons;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}