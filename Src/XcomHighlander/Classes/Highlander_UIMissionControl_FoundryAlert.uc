class Highlander_UIMissionControl_FoundryAlert extends UIMissionControl_FoundryAlert;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}

simulated function UpdateData()
{
    local TMCAlert kAlertData;

    kAlertData = GetMgr().m_kCurrentAlert;

    AS_SetTitle(Caps(kAlertData.txtTitle.StrValue));
    AS_SetSubTitle(class'UIMissionControl_EngineeringAlert'.default.m_strProjectCompleteSubTitle);
    AS_SetText(kAlertData.arrText[0].StrValue);

    UpdateButtonText();

    AS_SetImage(kAlertData.imgAlert.strPath);

    // Skip the base class's UpdateData or it'll change the image back to something invalid
    super(UIMissionControl_ProjectCompleteAlert).UpdateData();
}