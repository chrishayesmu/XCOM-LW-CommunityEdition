class LWCE_UIMissionControl_AbductionSelection extends UIMissionControl_AbductionSelection;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}

simulated function CloseAlert(optional int inputCode = -1)
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.CloseAlert(self, inputCode);
}

simulated function UpdateButtonText()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.UpdateButtonText(self);
}

simulated function UpdateSimpleAlertData()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.UpdateSimpleAlertData(self);
}