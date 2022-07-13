class LWCE_UIMissionControl_ExaltAlert extends UIMissionControl_ExaltAlert;

`include(generators.uci)

`LWCE_GENERATOR_ALERTWITHMULTIPLEBUTTONS

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}

simulated function UpdateData()
{
    local LWCE_TMCAlert kAlertData;

    kAlertData = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;
    AS_SetTitles(Caps(kAlertData.txtTitle.StrValue), kAlertData.arrText[0].StrValue);
    UpdateButtonText();
    super.UpdateData();
}