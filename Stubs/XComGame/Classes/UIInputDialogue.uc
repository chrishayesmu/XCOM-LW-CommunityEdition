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
};


var TInputDialogData m_kData;
var UINavigationHelp m_kHelpBar;
var delegate<TextInputClosedCallback> m_fnCallback;
var delegate<TextInputClosedCallback> m_fnCallbackCancelled;
var delegate<TextInputClosedCallback> m_fnCallbackAccepted;
var delegate<TextInputClosedCallback> __TextInputClosedCallback__Delegate;
var delegate<TextInputAcceptedCallback> __TextInputAcceptedCallback__Delegate;
var delegate<TextInputCancelledCallback> __TextInputCancelledCallback__Delegate;

delegate TextInputClosedCallback(string newText);

delegate TextInputAcceptedCallback(string newText);

delegate TextInputCancelledCallback(string newText);

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, TInputDialogData kData){}
simulated function OnInit(){}
simulated function UpdateButtonHelp(){}
simulated function bool RawInputHandler(name Key, int Actionmask, bool bCtrl, bool bAlt, bool bShift){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function OnMouseAccept(){}
simulated function bool OnAccept(optional string strOption){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string strOption){}
simulated function string ValidateResult(){}
final simulated function SetData(string Title, int maxChars, string textBoxText){}
final simulated function string AS_GetInputText(){}
