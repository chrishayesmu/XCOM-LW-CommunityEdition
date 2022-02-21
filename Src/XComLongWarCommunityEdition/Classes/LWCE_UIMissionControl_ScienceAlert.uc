class LWCE_UIMissionControl_ScienceAlert extends UIMissionControl_ScienceAlert;

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
    local TMCAlert kAlertData;

    kAlertData = GetMgr().m_kCurrentAlert;
    AS_SetTitle(class'UIUtilities'.static.CapsCheckForGermanScharfesS(kAlertData.txtTitle.StrValue));
    AS_SetSubTitle(m_strResearchCompleteSubTitle);
    AS_SetText(kAlertData.arrText[0].StrValue);
    UpdateButtonText();
    AS_SetImage(GetMgr().m_kCurrentAlert.imgAlert.strPath);
}