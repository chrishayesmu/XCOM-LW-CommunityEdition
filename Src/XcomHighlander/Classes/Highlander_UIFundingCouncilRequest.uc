class Highlander_UIFundingCouncilRequest extends UIFundingCouncilRequest;

simulated function XGPendingRequestsUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGPendingRequestsUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGPendingRequestsUI', none, -1, true));

        if (m_kLocalMgr == none)
        {
            m_kLocalMgr = Spawn(class'Highlander_XGPendingRequestsUI');
            m_kLocalMgr.m_kInterface = self;
        }
    }

    return m_kLocalMgr;
}