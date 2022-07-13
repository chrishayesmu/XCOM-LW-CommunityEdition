class LWCE_UIMissionControl_ExaltResearchHack extends UIMissionControl_ExaltResearchHack;

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
    AS_SetHeaderLabels(kAlertData.txtTitle.StrValue, class'UIUtilities'.static.CapsCheckForGermanScharfesS(kAlertData.arrText[0].StrValue), m_strConfirmLabel);
    AS_SetResearchHackData(kAlertData.arrText[3].StrValue, kAlertData.arrLabeledText[0].strLabel, kAlertData.arrLabeledText[0].StrValue, kAlertData.arrLabeledText[1].strLabel, kAlertData.arrLabeledText[1].StrValue, kAlertData.arrText[2].StrValue, kAlertData.arrLabeledText[2].strLabel, kAlertData.arrLabeledText[2].StrValue, kAlertData.arrText[1].StrValue);
    UpdateButtonText();
}