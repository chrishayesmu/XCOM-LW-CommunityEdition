class LWCE_UIFundingCouncilRequest extends UIFundingCouncilRequest;

simulated function XGPendingRequestsUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGPendingRequestsUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGPendingRequestsUI', none, -1, true));

        if (m_kLocalMgr == none)
        {
            m_kLocalMgr = Spawn(class'LWCE_XGPendingRequestsUI');
            m_kLocalMgr.m_kInterface = self;
        }
    }

    return m_kLocalMgr;
}