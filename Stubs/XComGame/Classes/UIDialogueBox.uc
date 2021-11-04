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
};

var const localized string m_strDefaultAcceptLabel;
var const localized string m_strDefaultCancelLabel;
var string m_sMouseNavigation;
var array<TDialogueBoxData> m_arrData;
var string strAccept;
var string strCancel;
var delegate<DialogBoxClosed> m_fnClosedCallback;
var delegate<DialogBoxClosed> __DialogBoxClosed__Delegate;
var delegate<ActionCallback> __ActionCallback__Delegate;
var delegate<ActionCallbackEx> __ActionCallbackEx__Delegate;

delegate DialogBoxClosed();
delegate ActionCallback(EUIAction eAction);
delegate ActionCallbackEx(EUIAction eAction, UICallbackData xUserData);

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function AddDialog(TDialogueBoxData kData){}
final simulated function RemoveDialog(){}
simulated function ClearDialogs(){}
simulated function UpdateDialogText(string kText){}
final simulated function Realize(){}
simulated function CheckUIHiddenForCinematics(){}
final simulated function TraceDialogsToConsole(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool TopIsModal(){}
simulated function bool DialogTypeIsShown(int Type){}
simulated function bool GetTopDialogBoxData(out TDialogueBoxData kData){}
simulated function bool ShowingDialog(){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string strOption){}
simulated function bool OnCancel(optional string strOption){}
function RefreshNavigationHelp(){}
simulated function Show(){}
simulated function Hide(){}
event Destroyed(){}
final simulated function AS_SetStyleNormal(){}
final simulated function AS_SetStyleNormalWithImage(){}
final simulated function AS_SetStyleWarning(){}
final simulated function AS_SetStyleAlert(){}
final simulated function AS_SetTitle(string Text){}
final simulated function AS_SetText(string Text){}
final simulated function AS_SetImage(string imagePath){}
simulated function AS_SetHelp(int Index, string Text, string buttonIcon){}
simulated function AS_SetMouseNavigationText(string Text, string buttonIcon){}
final simulated function AS_UseMouseNavigation(){}
final simulated function AS_UseControllerNavigation(){}
