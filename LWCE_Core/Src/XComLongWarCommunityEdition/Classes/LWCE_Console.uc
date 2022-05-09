class LWCE_Console extends Console;

function bool InputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = false)
{
    // The superclass version of this function looks at the input key and decides whether to open the console. In LWCE, we've moved the
    // console opening logic to conventional keybinds so they can be rebound easily by the player, so this function does much less.
    // We're basically just keeping the relevant parts of the flow from the parent class so don't expect this to make much sense by itself.

    if (Event == IE_Pressed)
    {
        bCaptureKeyInput = false;
    }

    return bCaptureKeyInput;
}

function OpenConsoleView()
{
    GotoState('Open');
    SetInputText("");
    SetCursorPos(0);
}

function OpenTypingView()
{
    GotoState('Typing');
    SetInputText("");
    SetCursorPos(0);
}