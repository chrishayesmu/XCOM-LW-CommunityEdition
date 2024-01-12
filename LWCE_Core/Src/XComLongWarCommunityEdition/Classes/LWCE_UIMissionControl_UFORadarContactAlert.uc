class LWCE_UIMissionControl_UFORadarContactAlert extends UIMissionControl_UFORadarContactAlert;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}

simulated function BeginInterception(XGShip_UFO kTarget)
{
    `LWCE_LOG_DEPRECATED_CLS(BeginInterception);
}

simulated function LWCE_BeginInterception(LWCE_XGShip kTarget)
{
    if (m_kInterceptMgr == none)
    {
        m_kInterceptMgr = Spawn(class'LWCE_XGInterceptionUI', self);
        LWCE_XGInterceptionUI(m_kInterceptMgr).m_arrEnemyShips.AddItem(kTarget);
        m_kInterceptMgr.Init(eIntView_JetSelection);
    }

    if (m_kInterceptMgr.m_akIntDistance.Length > 0)
    {
        m_nCachedState = 'ShipSelection';

        if (IsInited())
        {
            GotoState(m_nCachedState);
        }
    }
}

simulated function ClearMissionControlAlertReference()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.ClearMissionControlAlertReference(self);
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    return class'LWCE_UIMissionControl_AlertBase_Extensions'.static.AlertWithMultipleButtons_OnMouseEvent(self, Cmd, args);
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
     return class'LWCE_UIMissionControl_AlertBase_Extensions'.static.AlertWithMultipleButtons_OnUnrealCommand(self, Cmd, Arg);
}

simulated function UpdateButtonText()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.AlertWithMultipleButtons_UpdateButtonText(self);
}

simulated function UpdateData()
{
    local int colorState;
    local LWCE_TMCAlert kAlert;

    kAlert = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;
    colorState = `HQGAME.GetGameCore().GetHQ().IsHyperwaveActive() ? eUIState_Hyperwave : eUIState_Bad;

    AS_SetTitle(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.txtTitle.StrValue), colorState));
    AS_SetContact(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.arrLabeledText[0].strLabel), colorState), kAlert.arrLabeledText[0].StrValue);
    AS_SetLocation(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.arrLabeledText[1].strLabel), colorState), kAlert.arrLabeledText[1].StrValue);
    AS_SetSize(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.arrLabeledText[2].strLabel), colorState), kAlert.arrLabeledText[2].StrValue);
    AS_SetClass(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.arrLabeledText[3].strLabel), colorState), kAlert.arrLabeledText[3].StrValue);

    if (colorState == eUIState_Hyperwave)
    {
        AS_SetHyperwaveDataSlim(m_strHyperwavePanelTitle, Caps(kAlert.arrLabeledText[4].strLabel), kAlert.arrLabeledText[4].StrValue);
    }

    if (m_nCachedState == 'UFOContact')
    {
        UpdateButtonText();
    }
}

simulated function UpdateSimpleAlertData()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.UpdateSimpleAlertData(self);
}