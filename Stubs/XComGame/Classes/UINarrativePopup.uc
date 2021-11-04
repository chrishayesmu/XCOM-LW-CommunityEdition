class UINarrativePopup extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

var UINarrativeMgr m_kNarrativeMgr;
var string m_sMouseNavigation;
var bool bIsModal;
var name DisplayTag;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UINarrativeMgr kNarrativeMgr){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateDisplay(){}
simulated function bool OnAccept(optional string strOption){}
simulated function RefreshMouseState(){}
simulated function Show(){}
simulated function AS_SetTitle(string DisplayText){}
simulated function AS_SetText(string DisplayText){}
simulated function AS_SetType(int iType){}
simulated function AS_SetPortrait(string strPortrait){}
simulated function AS_SetMouseNavigationText(string str0, string str1){}
simulated function AS_SetHelp(int Index, string displayString, string Icon){}
simulated function AS_UseMouseNavigation(){}
simulated function AS_UseControllerNavigation(){}
