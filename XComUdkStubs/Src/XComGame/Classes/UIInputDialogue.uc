class UIInputDialogue extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

struct TInputDialogData
{
    var string strTitle;
    var string strInputBoxText;
    var int iMaxChars;
    var delegate<TextInputClosedCallback> fnCallback;
    var delegate<TextInputClosedCallback> fnCallbackCancelled;
    var delegate<TextInputClosedCallback> fnCallbackAccepted;

    structdefaultproperties
    {
        strTitle="<NO DATA PROVIDED>"
        iMaxChars=27
    }
};

var private TInputDialogData m_kData;
var private UINavigationHelp m_kHelpBar;
var delegate<TextInputClosedCallback> m_fnCallback;
var delegate<TextInputClosedCallback> m_fnCallbackCancelled;
var delegate<TextInputClosedCallback> m_fnCallbackAccepted;

delegate TextInputClosedCallback(string newText)
{
}

delegate TextInputAcceptedCallback(string newText)
{
}

delegate TextInputCancelledCallback(string newText)
{
}

defaultproperties
{
    m_kData=(strTitle="<NO DATA PROVIDED>",strInputBoxText="",iMaxChars=27)
    s_package="/ package/gfxInputDialogue/InputDialogue"
    s_screenId="gfxInputDialogue"
    e_InputState=eInputState_Consume
    s_name="theInputDialogueScreen"
}