class LWCE_UIStrategyComponent_Clock extends UIStrategyComponent_Clock;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', none, iStaringView, true));
    }

    return m_kLocalMgr;
}

event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}