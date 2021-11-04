class UIInputGate extends Actor
    notplaceable
    hidecategories(Navigation);
//complete stub

struct TButtonInputState
{
    var int Cmd;
    var bool bReportToKismet;
    var bool bIsLocked;
    var bool bIsValid;
};

var private XComPlayerController controllerRef;
var private UIFxsMovie manager;
var private array<TButtonInputState> m_arrButtons;
var private bool m_bIsActive;

simulated function Init();
simulated function bool OnUnrealCommand(int Cmd, int Action){}
simulated function Activate(bool bIsActive){}
private final simulated function TButtonInputState GetButtonState(int Cmd){}
simulated function SetGate(int Cmd, bool bReportToKismet, bool bLocked){}
simulated function DoUnrealCommandKismetEvent(TButtonInputState tButtonState){}
