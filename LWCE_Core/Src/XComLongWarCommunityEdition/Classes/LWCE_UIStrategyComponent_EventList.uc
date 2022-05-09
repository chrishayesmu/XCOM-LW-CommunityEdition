class LWCE_UIStrategyComponent_EventList extends UIStrategyComponent_EventList;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none && controllerRef != none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', UIMissionControl(screen), iStaringView));
    }

    return m_kLocalMgr;
}