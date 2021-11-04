class UI_FxsPanel extends Actor
    native(UI)
    notplaceable
    hidecategories(Navigation);

//complete stub
enum EWidgetColor
{
    eColor_Xcom,
    eColor_Alien,
    eColor_Attention,
    eColor_Good,
    eColor_Bad,
    eColor_White,
    eColor_Black,
    eColor_Red,
    eColor_Green,
    eColor_Blue,
    eColor_Yellow,
    eColor_Orange,
    eColor_Cyan,
    eColor_Purple,
    eColor_Gray,
    eColor_MAX
};

enum EColorShade
{
    eShade_Normal,
    eShade_Light,
    eShade_Dark,
    eShade_MAX
};
	
var bool b_DependantVariablesAreInitialized;
var bool b_CallOnInitOnDependantVariablesInitialized;
var bool b_IsInitialized;
var bool b_IsVisible;
var bool b_IsFinished;
var bool b_IsFocused;
var bool b_ShowOnInitUpdate;
var bool b_HideOnInitUpdate;
var bool b_OwnsMouseFocus;
var name s_name;
var name m_sFullMovieclipPath;
var XComPlayerController controllerRef;
var UIFxsMovie manager;
var UI_FxsScreen screen;
var UICacheMgr uicache;
var delegate<OnCommandCallback> m_fnOnCommand;

//var delegate<OnCommandCallback> __OnCommandCallback__Delegate;

delegate OnCommandCallback(string Cmd, string Arg){}
native simulated function OnInit();
final simulated function bool DependantVariablesAreInitialized(){}
final simulated function BaseOnDependantVariablesInitialized(){}
simulated function OnDependantVariablesInitialized();
simulated function bool CalcDependantVariablesAreInitialized(){}
simulated function PanelInit(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, optional delegate<OnCommandCallback> CommandFunction){}
native simulated function bool IsInited();
native simulated function Invoke(string sFunctionToCall, optional array<ASValue> myArray, optional bool verbose){}
native simulated function SetVariable(string sVariable, optional ASValue myValue);
native simulated function name GetMCPath();
native final simulated function PrintInfo();
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function bool IsFocused(){}
native simulated function Show();
native simulated function Hide();
native simulated function Remove();
native simulated function bool IsVisible();
native simulated function Finish();
native final simulated function RemoveReferences();
event Destroyed(){}
native simulated function bool CheckInputIsReleaseOrDirectionRepeat(int Cmd, int Arg);
native simulated function bool OnMouseEvent(int ucmd, array<string> parsedArgs);
native simulated function bool OnUnrealCommand(int ucmd, int Arg);

simulated state PanelInit_WaitForDependantVariablesToInit
{
    simulated function OnInit(){}
}

