class UIDialogueBox extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

enum EUIDialogBoxDisplay
{
    eDialog_Normal,
    eDialog_NormalWithImage,
    eDialog_Warning,
    eDialog_Alert,
    eDialog_MAX
};

enum EUIAction
{
    eUIAction_Accept,
    eUIAction_Cancel,
    eUIAction_Closed,
    eUIAction_MAX
};

struct TDialogueBoxData
{
    var EUIDialogBoxDisplay eType;
    var bool isShowing;
    var bool IsModal;
    var string strTitle;
    var string strText;
    var string strAccept;
    var string strCancel;
    var string strImagePath;
    var SoundCue sndIn;
    var SoundCue sndOut;
    var delegate<ActionCallback> fnCallback;
    var delegate<ActionCallbackEx> fnCallbackEx;
    var UICallbackData xUserData;

    structdefaultproperties
    {
        eType=eDialog_Normal
        strTitle="<DEFAULT TITLE>"
        strText="<DEFAULT BODY>"
    }
};

var const localized string m_strDefaultAcceptLabel;
var const localized string m_strDefaultCancelLabel;
var private string m_sMouseNavigation;
var private array<TDialogueBoxData> m_arrData;
var private string strAccept;
var private string strCancel;
var delegate<DialogBoxClosed> m_fnClosedCallback;

delegate DialogBoxClosed()
{
}

delegate ActionCallback(EUIAction eAction)
{
}

delegate ActionCallbackEx(EUIAction eAction, UICallbackData xUserData)
{
}

defaultproperties
{
    m_sMouseNavigation="theMouseNavigation"
    s_package="/ package/gfxDialogueBox/DialogueBox"
    s_screenId="gfxDialogueBox"
    e_InputState=eInputState_Evaluate
    b_OwnsMouseFocus=true
    s_name="theDialogueBox"
}