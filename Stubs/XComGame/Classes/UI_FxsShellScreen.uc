class UI_FxsShellScreen extends UI_FxsScreen
    native(UI)
    notplaceable
    hidecategories(Navigation);
//complete stub

var protected int m_iCurrentCommand;
var const localized string m_strDefaultHelp_Accept;
var const localized string m_strDefaultHelp_Cancel;
var const localized string m_strDefaultHelp_MouseNav_Accept;
var const localized string m_strDefaultHelp_MouseNav_Cancel;
var string m_strHelp_MouseNav_Accept;
var string m_strHelp_MouseNav_Cancel;
var UINavigationHelp m_kHelpBar;
//var delegate<HelpbarDelgate> __HelpbarDelgate__Delegate;

delegate HelpbarDelgate();
simulated function ShellScreenInit(XComPlayerController _controllerRef, UIFxsMovie _manager, coerce optional name helpbarId=class'UINavigationHelp'.default.s_name, optional delegate<HelpbarDelgate> helpbarOnLoadCallback){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function MouseNextScreen(){}
simulated function MousePrevScreen(){}
simulated function NavNextScreen(){}
simulated function Show(){}
simulated function SetHelp(int Index, string Text, string buttonIcon){}
simulated function AS_SetHelp(int Index, string Text, string buttonIcon){}
