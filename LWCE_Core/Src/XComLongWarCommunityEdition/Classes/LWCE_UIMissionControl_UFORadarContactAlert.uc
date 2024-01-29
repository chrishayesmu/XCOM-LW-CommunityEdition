class LWCE_UIMissionControl_UFORadarContactAlert extends UIMissionControl_UFORadarContactAlert
    dependson(LWCE_XGInterceptionUI);

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
    super.OnInit();
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

    if (LWCE_XGInterceptionUI(m_kInterceptMgr).m_arrCEShipOptions.Length > 0)
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

    UpdateButtonText();
}

simulated function UpdateSimpleAlertData()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.UpdateSimpleAlertData(self);
}

state UFOContact
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
    }
}

state ShipSelection
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
    }

    simulated function UpdateData()
    {
        local LWCE_TShipOption kShipOption;
        local string strShipIconLabel;

        global.UpdateData();

        foreach LWCE_XGInterceptionUI(m_kInterceptMgr).m_arrCEShipOptions(kShipOption)
        {
            strShipIconLabel = kShipOption.kShip.IsType('Firestorm') ? "firestorm" : "interceptor"; // TODO expand
            AS_AddShip(kShipOption.txtShipName.StrValue, kShipOption.txtOffense.StrValue, class'UIUtilities'.static.GetHTMLColoredText(kShipOption.txtStatus.StrValue, kShipOption.txtStatus.iState), strShipIconLabel, kShipOption.iState == eUIState_Disabled);
        }

        AS_ActivateShipList(Caps(m_kInterceptMgr.m_strLabelLaunchFightersPC));
        RealizeSelected(256);
    }

    simulated function OnAccept()
    {
        local LWCE_XGInterceptionUI kMgr;

        kMgr = LWCE_XGInterceptionUI(m_kInterceptMgr);

        if (kMgr.m_arrCEShipOptions.Length == 0 || kMgr.m_arrCEShipOptions[255 & m_iSelectedShip].iState == eUIState_Disabled)
        {
            kMgr.PlayBadSound();
            return;
        }

        Remove();
        CloseAlert();

        LWCE_XGInterception(kMgr.m_kInterception).ToggleFriendlyShip(kMgr.m_arrCEShipOptions[m_iSelectedShip & 255].kShip);
        kMgr.OnLaunch();
    }

    simulated function bool OnMouseEvent(int Cmd, array<string> args)
    {
        local LWCE_XGShip kShip;
        local string callbackObj, tmp;
        local int buttonCode;

        callbackObj = args[args.Length - 1];

        if (m_iSelectedShip != INDEX_NONE)
        {
            kShip = LWCE_XGInterceptionUI(m_kInterceptMgr).m_arrCEShipOptions[m_iSelectedShip & 255].kShip;
        }

        if (InStr(callbackObj, "button") == INDEX_NONE)
        {
            if (InStr(callbackObj, "ship") != INDEX_NONE)
            {
                tmp = Split(callbackObj, "ship", true);
                buttonCode = int(tmp);
            }
            else
            {
                if (InStr(callbackObj, "bal") != INDEX_NONE)
                {
                    kShip.m_nmEngagementStance = 'Balanced';
                    buttonCode = 1 << 8;
                }

                if (InStr(callbackObj, "agg") != INDEX_NONE)
                {
                    kShip.m_nmEngagementStance = 'Aggressive';
                    buttonCode = 2 << 8;
                }

                if (InStr(callbackObj, "def") != INDEX_NONE)
                {
                    kShip.m_nmEngagementStance = 'Defensive';
                    buttonCode = 3 << 8;
                }
            }

            RealizeSelected(buttonCode);

            if (buttonCode > 255)
            {
                if (Cmd == class'UI_FxsInput'.const.FXS_L_MOUSE_UP)
                {
                    OnAccept();
                }
            }
        }
        else if (Cmd == class'UI_FxsInput'.const.FXS_L_MOUSE_UP)
        {
            tmp = GetRightMost(callbackObj);

            if (tmp != "")
            {
                buttonCode = int(tmp);
            }
            else
            {
                buttonCode = -1;
            }

            if (buttonCode > 0)
            {
                CloseAlert(-1);
            }
            else
            {
                CloseAlert(0);
            }
        }

        return true;
    }

    simulated function bool OnUnrealCommand(int Cmd, int Arg)
    {
        local LWCE_XGInterceptionUI kMgr;
        local int newSelection;
        local bool bHandled;

        if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
        {
            return true;
        }

        kMgr = LWCE_XGInterceptionUI(m_kInterceptMgr);
        bHandled = true;

        switch (Cmd)
        {
            case class'UI_FxsInput'.const.FXS_DPAD_UP:
            case class'UI_FxsInput'.const.FXS_ARROW_UP:
            case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
                newSelection = (m_iSelectedShip & 255) - 1;

                if (newSelection < 0)
                {
                    newSelection = kMgr.m_arrCEShipOptions.Length - 1;
                }

                RealizeSelected(newSelection);

                if (kMgr.m_arrCEShipOptions.Length > 1)
                {
                    PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
                }

                break;
            case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
            case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
            case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
                newSelection = (m_iSelectedShip & 255) + 1;

                if (newSelection >= kMgr.m_arrCEShipOptions.Length)
                {
                    newSelection = 0;
                }

                RealizeSelected(newSelection);

                if (kMgr.m_arrCEShipOptions.Length > 1)
                {
                    PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
                }

                break;
            case class'UI_FxsInput'.const.FXS_DPAD_LEFT:
            case class'UI_FxsInput'.const.FXS_ARROW_LEFT:
            case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_LEFT:
                newSelection = (m_iSelectedShip >> 8) - 1;

                if (newSelection < 1)
                {
                    newSelection = 3;
                }

                newSelection = newSelection << 8;
                RealizeSelected(newSelection);
                PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);

                break;
            case class'UI_FxsInput'.const.FXS_DPAD_RIGHT:
            case class'UI_FxsInput'.const.FXS_ARROW_RIGHT:
            case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_RIGHT:
                newSelection = (m_iSelectedShip >> 8) + 1;

                if (newSelection > 3)
                {
                    newSelection = 1;
                }

                newSelection = newSelection << 8;
                RealizeSelected(newSelection);
                PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);

                break;
            case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
            case class'UI_FxsInput'.const.FXS_KEY_ENTER:
                OnAccept();
                break;
            case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
            case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
                OnCancel();
                break;
            default:
                bHandled = false;
                break;
        }

        return bHandled;
    }

    simulated function RealizeSelected(int newSelection)
    {
        if (LWCE_XGInterceptionUI(m_kInterceptMgr).m_arrCEShipOptions.Length == 0)
        {
            global.RealizeSelected(newSelection);
            return;
        }

        AS_SetShipFocus(m_iSelectedShip, false);

        // TODO: we shouldn't need the bit fiddling stuff, it was just for stance management in LW 1.0
        if (newSelection > 255)
        {
            m_iSelectedShip = (m_iSelectedShip & 255) | newSelection;
        }
        else
        {
            m_iSelectedShip = (m_iSelectedShip & 65280) | newSelection;
        }

        AS_SetShipFocus(m_iSelectedShip, true);
    }
}