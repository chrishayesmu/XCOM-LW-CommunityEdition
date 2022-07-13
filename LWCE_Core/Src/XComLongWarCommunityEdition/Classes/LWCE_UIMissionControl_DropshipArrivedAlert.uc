class LWCE_UIMissionControl_DropshipArrivedAlert extends UIMissionControl_DropshipArrivedAlert;

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
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.CloseAlert(self, inputCode);
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    return class'LWCE_UIMissionControl_AlertBase_Extensions'.static.OnMouseEvent(self, Cmd, args);
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local int newSelection, inputCode;
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
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
            GetMgr().PlayScrollSound();
            newSelection = m_iSelectedBtn - 1;

            if (newSelection < 0)
            {
                newSelection = NUM_BUTTONS - 1;
            }

            RealizeSelected(newSelection);
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
            GetMgr().PlayScrollSound();
            newSelection = m_iSelectedBtn + 1;

            if (newSelection >= NUM_BUTTONS)
            {
                newSelection = 0;
            }

            RealizeSelected(newSelection);
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
            if (m_iSelectedBtn < kAlertData.mnuReplies.arrOptions.Length && kAlertData.mnuReplies.arrOptions[m_iSelectedBtn].iState == 1)
            {
                GetMgr().PlayBadSound();
                return bHandled;
            }

            if (m_iSelectedBtn > 0)
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
            GetMgr().PlayBadSound();
            return bHandled;
    }

    bHandled = false;

    if (bCloseAlert)
    {
        CloseAlert(inputCode);
    }

    return bHandled;
}

simulated function UpdateButtonText()
{
    local int I;
    local LWCE_TMCAlert kAlertData;
    local TMenuOption kOption;

    kAlertData = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;

    for (I = 0; I < kAlertData.mnuReplies.arrOptions.Length; I++)
    {
        kOption = kAlertData.mnuReplies.arrOptions[I];
        AS_SetButtonData(I, Caps(kOption.strText), kOption.iState == 1);
    }

    if (!manager.IsMouseActive())
    {
        RealizeSelected(m_iSelectedBtn);
    }
}

simulated function UpdateSimpleAlertData()
{
    class'LWCE_UIMissionControl_AlertBase_Extensions'.static.UpdateSimpleAlertData(self);
}