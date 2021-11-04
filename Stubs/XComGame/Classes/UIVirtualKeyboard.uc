class UIVirtualKeyboard extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

var protected string m_kLayoutRegular;
var protected string m_kLayoutShift;
var protected string m_kLayoutShiftDisplay;
var protected string m_kLayoutAltGr;
var string m_sTitle;
var string m_sDefault;
var delegate<delActionAccept> __delActionAccept__Delegate;
var delegate<delActionCancel> __delActionCancel__Delegate;

delegate delActionAccept(string userInput);

delegate delActionCancel();

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, delegate<delActionAccept> del_OnAccept, delegate<delActionCancel> del_OnCancel){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int ucmd, int Arg){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function Remove(){}
simulated function InitializeLayouts(){}
simulated function PressKeyboardKey(string sKey){}
simulated function SetTitle(string DisplayText){}
simulated function SetFunctionButton(int Index, string buttonIcon, string DisplayText){}
simulated function SetDefaultText(string DisplayText){}
