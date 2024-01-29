class LWCE_UIMissionControl_TerrorAlert extends UIMissionControl_TerrorAlert;

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

    AS_SetTitle(Caps(kAlertData.arrLabeledText[0].strLabel));
    AS_SetCountryName(Caps(kAlertData.arrLabeledText[0].StrValue));
    AS_SetPanicLevel(Caps(kAlertData.arrLabeledText[1].strLabel), kAlertData.kData.Data[0].I);
    AS_SetDifficulty(Caps(kAlertData.arrLabeledText[2].strLabel), kAlertData.arrLabeledText[2].StrValue);
    UpdateButtonText();
}