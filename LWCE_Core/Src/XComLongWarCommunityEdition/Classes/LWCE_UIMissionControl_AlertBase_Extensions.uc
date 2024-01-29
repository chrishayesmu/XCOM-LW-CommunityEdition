class LWCE_UIMissionControl_AlertBase_Extensions extends Object
    abstract
    dependson(LWCETypes, LWCE_XGMissionControlUI);

static simulated function ClearMissionControlAlertReference(UIMissionControl_AlertBase kSelf)
{
    if (UIMissionControl(kSelf.screen) != none)
    {
        UIMissionControl(kSelf.screen).ClearAlertReference(kSelf);
    }
}

static simulated function CloseAlert(UIMissionControl_AlertBase kSelf, optional int inputCode = -1)
{
    local LWCE_XGMissionControlUI kMgr;

    kMgr = LWCE_XGMissionControlUI(kSelf.GetMgr());

    if (inputCode == -1 || kMgr.m_kCECurrentAlert.mnuReplies.arrOptions[inputCode].iState != eUIState_Disabled)
    {
        kSelf.Remove();
    }

    kMgr.OnAlertInput(inputCode);
}

static function bool AlertWithMultipleButtons_OnMouseEvent(UIMissionControl_AlertWithMultipleButtons kSelf, int Cmd, array<string> args)
{
    local string callbackObj, tmp;
    local int buttonCode;
    local bool bHandled;
    local LWCE_XGMissionControlUI kMgr;

    kMgr = LWCE_XGMissionControlUI(kSelf.GetMgr());
    bHandled = true;


    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            callbackObj = args[args.Length - 1];

            if (Len(callbackObj) == Len("button"))
            {
                callbackObj = args[args.Length - 2];
            }

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
                if (kMgr.m_kCECurrentAlert.mnuReplies.arrOptions.Length > 1 && kMgr.m_kCECurrentAlert.mnuReplies.arrOptions[1].iState == eUIState_Disabled)
                {
                    kMgr.PlayBadSound();
                    return bHandled;
                }

                kSelf.CloseAlert(-1);
            }
            else
            {
                kSelf.CloseAlert(0);
            }

            break;
        default:
            bHandled = false;
            break;
    }

    return bHandled;
}

static function bool OnMouseEvent(UIMissionControl_AlertBase kSelf, int Cmd, array<string> args)
{
    local string callbackObj, tmp;
    local int buttonCode;
    local LWCE_XGMissionControlUI kMgr;

    kMgr = LWCE_XGMissionControlUI(kSelf.GetMgr());

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            callbackObj = args[args.Length - 2];

            if (InStr(callbackObj, "button") == INDEX_NONE)
            {
            }
            else
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
                    if (kMgr.m_kCECurrentAlert.mnuReplies.arrOptions.Length > 1 && kMgr.m_kCECurrentAlert.mnuReplies.arrOptions[1].iState == eUIState_Disabled)
                    {
                        kMgr.PlayBadSound();
                        return false;
                    }

                    kSelf.CloseAlert(-1);
                }
                else
                {
                    kSelf.CloseAlert(0);
                }
            }
    }

    return true;
}

static function bool AlertWithMultipleButtons_OnUnrealCommand(UIMissionControl_AlertWithMultipleButtons kSelf, int Cmd, int Arg)
{
    local LWCE_TMCAlert kAlert;
    local int newSelection, inputCode;
    local bool bHandled, bCloseAlert;

    kAlert = LWCE_XGMissionControlUI(kSelf.GetMgr()).m_kCECurrentAlert;

    if (!kSelf.CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
    {
        return true;
    }

    bHandled = true;
    bCloseAlert = false;

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
        case class'UI_FxsInput'.const.FXS_KEY_W:
            kSelf.GetMgr().PlayScrollSound();
            newSelection = kSelf.m_iSelectedBtn - 1;

            if (newSelection < 0)
            {
                newSelection = kSelf.NUM_BUTTONS - 1;
            }

            kSelf.RealizeSelected(newSelection);
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
        case class'UI_FxsInput'.const.FXS_KEY_S:
            kSelf.GetMgr().PlayScrollSound();
            newSelection = kSelf.m_iSelectedBtn + 1;

            if (newSelection >= kSelf.NUM_BUTTONS)
            {
                newSelection = 0;
            }

            kSelf.RealizeSelected(newSelection);
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
        case class'UI_FxsInput'.const.FXS_KEY_SPACEBAR:
            if (kSelf.m_iSelectedBtn < kAlert.mnuReplies.arrOptions.Length && kAlert.mnuReplies.arrOptions[kSelf.m_iSelectedBtn].iState == eUIState_Disabled)
            {
                kSelf.GetMgr().PlayBadSound();
                return bHandled;
            }

            if (kSelf.m_iSelectedBtn > 0)
            {
                inputCode = -1;
            }
            else
            {
                inputCode = 0;
            }

            bCloseAlert = true;
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
        case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
            if (kAlert.mnuReplies.arrOptions.Length > 1 && kAlert.mnuReplies.arrOptions[1].iState == eUIState_Disabled)
            {
                kSelf.GetMgr().PlayBadSound();
                return bHandled;
            }

            inputCode = -1;
            bCloseAlert = true;
            break;
        default:
            bHandled = false;
            break;
    }

    if (bCloseAlert)
    {
        kSelf.CloseAlert(inputCode);
    }

    return bHandled;
}

static function AlertWithMultipleButtons_UpdateButtonText(UIMissionControl_AlertWithMultipleButtons kSelf)
{
    local int I;
    local LWCE_TMCAlert kAlertData;
    local TMenuOption kOption;

    kAlertData = LWCE_XGMissionControlUI(kSelf.GetMgr()).m_kCECurrentAlert;

    for (I = 0; I < kAlertData.mnuReplies.arrOptions.Length; I++)
    {
        kOption = kAlertData.mnuReplies.arrOptions[I];
        kSelf.AS_SetButtonData(I, Caps(kOption.strText), kOption.iState == eUIState_Disabled);
    }

    if (!kSelf.manager.IsMouseActive())
    {
        kSelf.RealizeSelected(kSelf.m_iSelectedBtn);
    }
}

static function ProjectCompleteAlert_UpdateData(UIMissionControl_ProjectCompleteAlert kSelf)
{
    local int Index;
    local string strRebatesTitle, strRebatesData;
    local LWCE_TMCAlert kAlertData;

    kAlertData = LWCE_XGMissionControlUI(kSelf.GetMgr()).m_kCECurrentAlert;

    if (kAlertData.arrText.Length > 1)
    {
        strRebatesTitle = kAlertData.arrText[1].StrValue;
        strRebatesData = "";

        for (Index = 2; Index < kAlertData.arrText.Length; Index++)
        {
            if (Len(strRebatesData) > 0)
            {
                strRebatesData $= "\n";
            }

            strRebatesData $= class'UIUtilities'.static.GetHTMLColoredText(kAlertData.arrText[Index].StrValue, kAlertData.arrText[Index].iState);
        }

        kSelf.AS_SetRebates(Caps(strRebatesTitle), strRebatesData);
    }
}

static function UpdateButtonText(UIMissionControl_AlertBase kSelf)
{
    local LWCE_XGMissionControlUI kMgr;

    kMgr = LWCE_XGMissionControlUI(kSelf.GetMgr());

    kSelf.AS_SetButtonText(Caps(kMgr.m_kCECurrentAlert.mnuReplies.arrOptions[0].strText));
}

static function UpdateSimpleAlertData(UIMissionControl_AlertBase kSelf)
{
    local LWCE_TMCAlert kAlertData;

    kAlertData = LWCE_XGMissionControlUI(kSelf.GetMgr()).m_kCECurrentAlert;

    if (kAlertData.txtTitle.StrValue != "")
    {
        kSelf.AS_SetTitle(Caps(kAlertData.txtTitle.StrValue));
    }

    if (kAlertData.arrText.Length > 0 && kAlertData.arrText[0].StrValue != "")
    {
        kSelf.AS_SetText(kAlertData.arrText[0].StrValue);
    }

    kSelf.UpdateButtonText();
}