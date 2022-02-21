class LWCE_UIDebugMenu extends UIDebugMenu;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager)
{
    `LWCE_LOG_CLS("Init");
    super.Init(_controllerRef, _manager);
}

simulated function bool OnUnrealCommand(int ucmd, int Actionmask)
{
    if (!CheckInputIsReleaseOrDirectionRepeat(ucmd, Actionmask))
    {
        return true;
    }

    switch (ucmd)
    {
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
            OnUAccept();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_START:
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
            OnUCancel();
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
            OnUDPadUp();
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
            OnUDPadDown();
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_LEFT:
        case class'UI_FxsInput'.const.FXS_ARROW_LEFT:
        case class'UI_FxsInput'.const.FXS_DPAD_RIGHT:
        case class'UI_FxsInput'.const.FXS_ARROW_RIGHT:
            OnToggleFocus();
            break;
        default:
            break;
    }

    return true;
}
