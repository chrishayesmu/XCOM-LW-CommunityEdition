class UIObjectivesPopup extends UI_FxsScreen;
//complete stub

var const localized string m_strAcceptLabel;
var string m_sMouseNavigation;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function Dispose(){}
simulated function RealizeCurrentObjective(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string strOption){}
function RefreshMouseState(){}
simulated function Show(){}
simulated function AS_UseMouseNavigation(){}
simulated function AS_UseControllerNavigation(){}
simulated function AS_SetTitle(string Text){}
simulated function AS_SetText(string Text){}
simulated function AS_SetImage(string imagePath){}
simulated function AS_SetHelp(int Index, string Text, string buttonIcon){}
simulated function AS_SetMouseNavigationText(string Text, string buttonIcon){}
