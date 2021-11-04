class UI_FxsScreen extends UI_FxsPanel
    native(UI)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EUIInputState
{
    eInputState_None,
    eInputState_Evaluate,
    eInputState_Consume,
    eInputState_ConsumeAndIgnore,
    eInputState_MAX
};

struct Menu
{
    var int iSelection;
    var int iMaxLabels;
    var int iMaxIndexes;
    var array<string> aLabels;
    var array<int> aLookupValues;
    var array<int> aIndexes;
};

var name s_package;
var name s_screenId;
var name MCPath;
var bool m_bStopMusicOnExit;
var bool m_bAllowShowDuringCinematic;
var bool m_bPreCinematicVisible;
var bool m_bAnimateIntro;
var bool m_bAnimateOutro;
var bool m_bDelayRemove;
var int m_watchVar_OnCinematicMode;
var array<UI_FxsPanel> panels;
var EUIInputState e_InputState;

simulated function BaseInit(XComPlayerController _controller, UIFxsMovie _manager, optional delegate<OnCommandCallback> CommandFunction){}
simulated function OnInit(){}
simulated function name GetPackage(){}
simulated function name GetScreenId(){}
simulated function name GetMCPath(){}
simulated function AddPanel(UI_FxsPanel panel){}
simulated function RemovePanel(UI_FxsPanel panel){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function bool OnOption(optional string Arg){ }
simulated function bool OnAccept(optional string Arg){    }
simulated function bool OnCancel(optional string Arg){   }
simulated function Update(){}
simulated function OnCinematicMode(){}
simulated function AllowShowDuringCinematic(bool bShow){   }
native simulated function bool AcceptsInput();
native simulated function bool ConsumesInput();
native simulated function bool EvaluatesInput();
native simulated function bool IsMouseGate();
native simulated function FlushPressedKeys();
native function bool IsFinished();
simulated event ScreenFinish(){}
simulated function MarkForDelayedRemove(){}
simulated function bool IsMarkedForRemoval(){}
simulated function SetInputState(int eInputState){}
native simulated function Remove();
event Destroyed(){}
