class LWCE_UIMissionControl_AlertBase extends UIMissionControl_AlertBase;

`include(generators.uci)

`LWCE_GENERATOR_ALERTBASE

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}