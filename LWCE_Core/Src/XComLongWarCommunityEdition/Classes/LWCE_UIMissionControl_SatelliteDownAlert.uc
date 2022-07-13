class LWCE_UIMissionControl_SatelliteDownAlert extends UIMissionControl_SatelliteDownAlert;

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
    AS_SetSatteliteDownReprocussions(kAlertData.arrText[1].StrValue, kAlertData.arrText.Length > 2 ? kAlertData.arrText[2].StrValue : "");
}