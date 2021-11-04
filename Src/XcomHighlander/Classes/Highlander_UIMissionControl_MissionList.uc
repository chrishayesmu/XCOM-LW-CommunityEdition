class Highlander_UIMissionControl_MissionList extends UIMissionControl_MissionList;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGMissionControlUI', (self), iStaringView));
    }

    return m_kLocalMgr;
}