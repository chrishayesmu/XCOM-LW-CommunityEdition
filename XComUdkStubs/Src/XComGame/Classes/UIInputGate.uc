class UIInputGate extends Actor
    notplaceable
    hidecategories(Navigation);

struct TButtonInputState
{
    var int Cmd;
    var bool bReportToKismet;
    var bool bIsLocked;
    var bool bIsValid;

    structdefaultproperties
    {
        Cmd=-1
        bReportToKismet=true
        bIsLocked=true
    }
};

var private XComPlayerController controllerRef;
var private UIFxsMovie manager;
var private array<TButtonInputState> m_arrButtons;
var private bool m_bIsActive;