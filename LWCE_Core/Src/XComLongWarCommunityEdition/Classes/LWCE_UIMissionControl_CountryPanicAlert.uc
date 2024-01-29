class LWCE_UIMissionControl_CountryPanicAlert extends UIMissionControl_CountryPanicAlert;

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

    kAlertData = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;

    super(UIMissionControl_AlertBase).OnInit();

    AS_SetCountryImageLabel(class'UIUtilities'.static.GetCountryLabel(kAlertData.imgAlert.iImage));
    AS_SetPanicLevel(Caps(kAlertData.arrText[1].StrValue), kAlertData.kData.Data[0].I);
    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Red);
}