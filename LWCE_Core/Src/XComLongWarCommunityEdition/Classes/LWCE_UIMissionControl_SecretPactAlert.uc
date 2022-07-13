class LWCE_UIMissionControl_SecretPactAlert extends UIMissionControl_SecretPactAlert;

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

simulated function OnInit()
{
    local LWCE_TMCAlert kAlertData;

    super(UIMissionControl_AlertBase).OnInit();

    kAlertData = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;
    AS_SetTitle(Caps(kAlertData.arrLabeledText[0].strLabel));
    AS_SetSubTitle(Caps(kAlertData.arrLabeledText[0].StrValue));
    AS_SetCountryImageLabel(class'UIUtilities'.static.GetCountryLabel(kAlertData.imgAlert.iImage));

    if (kAlertData.arrText.Length == 2)
    {
        AS_SetPanicLevel(Caps(kAlertData.arrText[1].StrValue), kAlertData.iNumber);
        AS_SetText(kAlertData.arrText[0].StrValue);
    }
    else
    {
        AS_SetPanicLevel("", -1);
        AS_SetText(kAlertData.arrText[0].StrValue $ "<br><br>" $ class'UIUtilities'.static.GetHTMLColoredText(kAlertData.arrText[2].StrValue, eUIState_Warning));
    }
}