class LWCE_UIMissionControl_AugmentationCompleteAlert extends UIMissionControl_AugmentationCompleteAlert;

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

    AS_SetTitle(Caps(kAlertData.txtTitle.StrValue));
    AS_SetSubTitle(class'UIMissionControl_EngineeringAlert'.default.m_strProjectCompleteSubTitle);
    AS_SetText(kAlertData.arrText[0].StrValue);
    UpdateButtonText();

    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.ProjectCompleteAlert_UpdateData(self);
}