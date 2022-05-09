class LWCE_UIMissionControl_ExaltAlert extends UIMissionControl_ExaltAlert;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}