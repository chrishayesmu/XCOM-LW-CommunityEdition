class UIMultiplayerChatManager extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

const MY_MESSAGE_COLOR_HTML = "B9FFFF";
const OPPONENT_MESSAGE_COLOR_HTML = "EE1C25";

var bool m_bIsActive;
var bool m_bMuteChime;
var bool m_bMuteChat;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnUnrealCommand(int ucmd, int Arg){}
simulated function bool RawInputHandler(name Key, int Actionmask, bool bCtrl, bool bAlt, bool bShift){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function OpenChat(){}
simulated function CloseChat(){}
simulated function AddMessage(string Sender, string Text, bool isFromLocalPlayer){}
simulated function string SanitizeInputText(string txt){}
simulated function GameEnded(){}
event Destroyed(){}
simulated function AS_AppendText(string txt){}
simulated function string AS_GetInputText(){}
