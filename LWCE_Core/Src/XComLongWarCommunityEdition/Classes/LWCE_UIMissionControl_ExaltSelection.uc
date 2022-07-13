class LWCE_UIMissionControl_ExaltSelection extends UIMissionControl_ExaltSelection;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}

simulated function CloseAlert(optional int inputCode = -1)
{
    if (inputCode == -1)
    {
        Remove();
        GetMgr().OnAlertInput(99);
    }
    else if (LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert.mnuReplies.arrOptions[inputCode].iState != eUIState_Disabled)
    {
        Remove();
        GetMgr().OnAlertInput(m_iSelectedBtn);
    }
    else
    {
        GetMgr().OnAlertInput(m_iSelectedBtn);
    }
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    local string callbackObj, tmp;
    local bool bHandled;

    bHandled = true;

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            callbackObj = args[args.Length - 1];

            if (Len(callbackObj) == Len("button"))
            {
                callbackObj = args[args.Length - 2];
            }

            tmp = Right(callbackObj, 1);

            if (tmp != "")
            {
                m_iSelectedBtn = int(tmp);
            }
            else
            {
                m_iSelectedBtn = -1;
            }

            if (m_iSelectedBtn == 0 && LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert.mnuReplies.arrOptions[0].iState == eUIState_Disabled)
            {
                GetMgr().PlayBadSound();
                return bHandled;
            }

            CloseAlert(m_iSelectedBtn);
            break;
        default:
            bHandled = false;
            break;
    }

    return bHandled;
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local int inputCode;
    local bool bHandled, bCloseAlert;
    local LWCE_TMCAlert kAlertData;

    kAlertData = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;

    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
    {
        return true;
    }

    bHandled = true;
    bCloseAlert = false;

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
        case class'UI_FxsInput'.const.FXS_KEY_SPACEBAR:
            if (m_iSelectedBtn < kAlertData.mnuReplies.arrOptions.Length && kAlertData.mnuReplies.arrOptions[m_iSelectedBtn].iState == 1)
            {
                GetMgr().PlayBadSound();
                return bHandled;
            }

            if (m_iSelectedBtn > 1)
            {
                inputCode = -1;
            }
            else
            {
                inputCode = 0;
            }

            bCloseAlert = true;

            if (bCloseAlert)
            {
                CloseAlert(inputCode);
            }

            break;
        default:
            bHandled = false;
            break;
    }

    if (!bHandled)
    {
        bHandled = super.OnUnrealCommand(Cmd, Arg);
    }

    return bHandled;
}

simulated function RefreshButtons()
{
    local LWCE_TMCAlert kAlertData;

    kAlertData = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;

    if (GetMgr().EXALT().IsOperativeInField() && kAlertData.mnuReplies.arrOptions[0].iState != 1)
    {
        kAlertData.mnuReplies.arrOptions[0].iState = eUIState_Disabled;
    }

    UpdateButtonText();
}

simulated function UpdateButtonText()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.AlertWithMultipleButtons_UpdateButtonText(self);
}

simulated function UpdateData()
{
    local LWCE_TMCAlert kAlertData;

    kAlertData = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;
    AS_SetHeaderLabels(kAlertData.txtTitle.StrValue, class'UIUtilities'.static.CapsCheckForGermanScharfesS(kAlertData.arrText[0].StrValue), m_strConfirmLabel);

    if (int(kAlertData.arrText[4].StrValue) == 2)
    {
        AS_SetPanicLevel(m_strPanicLabel, int(kAlertData.arrText[3].StrValue));
    }
    else
    {
        AS_SetPanicLevel("", -1);
    }

    AS_SetData(class'UIUtilities'.static.CapsCheckForGermanScharfesS(kAlertData.arrText[1].StrValue), kAlertData.arrText[2].StrValue, kAlertData.imgAlert.iImage);
    UpdateButtonText();
}

simulated function UpdateSimpleAlertData()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.UpdateSimpleAlertData(self);
}