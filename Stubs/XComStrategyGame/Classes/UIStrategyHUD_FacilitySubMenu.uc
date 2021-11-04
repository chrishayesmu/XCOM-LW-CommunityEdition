class UIStrategyHUD_FacilitySubMenu extends UI_FxsPanel
    implements(IScreenMgrInterface);

//complete stub
struct UIFacilitySubMenuOption
{
    var int iIndex;
    var string strLabel;
    var int iState;
    var string strHelp;
};

var protected int m_iCurrentSelection;
var protected array<UIFacilitySubMenuOption> m_arrUIOptions;
var protected int m_iView;
var protected bool m_bIsFocused;
var bool bItemsLoaded;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, int iView){}
simulated function OnInit(){}
function OnFlashCommand(string Cmd, string Arg){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
protected simulated function CreateMenuOptions(TMenu tMenuOptionsData){}
protected simulated function UpdateDisplay(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function bool HasFocus(){}
simulated function HideSubMenuDuringSetupPhase(){}
simulated function OnAccept();
simulated function OnCancel(){}
simulated function OnDeactivate(){}
final simulated function AS_AddOption(int Index, string Text, int State){}
simulated function RealizeSelected(){}
simulated function AS_SetHelpText(string displayString){}
function GoToView(int iView);

function UnlockItems(array<TItemUnlock> arrUnlocks);

function UnlockItem(TItemUnlock kUnlock);
