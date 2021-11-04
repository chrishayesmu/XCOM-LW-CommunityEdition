class UISquadSelect_SquadList extends UI_FxsPanel;

struct UISquadList_UnitBox
{
    var int iIndex;
    var string strName;
    var string strNickName;
    var string classDesc;
    var string classLabel;
    var string item1;
    var string item2;
    var int iStatus;
    var bool bPromote;
    var bool bEmpty;
    var bool bUnavailable;
    var bool bHint;
};

var const localized string m_strPromote;
var const localized string m_strAddUnit;
var const localized string m_strEditUnit;
var const localized string m_strClearUnit;
var const localized string m_strBackpackLabel;
var int m_iCurrentSelection;
var array<UISquadList_UnitBox> m_arrUIOptions;
var array<int> m_arrFillOrderIndex;
var bool bCanNavigate;
var bool m_bInSoldierView;
var int m_iMaxSlots;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, XGMission kMission, bool bNav){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function UnloadSoldier(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function int RefreshSelectionBasedOnMousePath(array<string> args){}
function SelectPrevAvailableSlot(){}
function SelectNextAvailableSlot(){}
simulated function UpdateData(){}
simulated function UpdateDisplay(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function Show(){}
simulated function Hide(){}
simulated function OnAccept(){}
simulated function OnCancel();
simulated function OnDeactivate(){}
simulated function UISquadList_UnitBox CreateSoldierOption(TSoldierLoadout kLoadout){}
simulated function AS_SetUnitInfo(int Index, int Status, string unitName, string unitNickName, string classDesc, string classLabel, string item1, string item2, string promote){}
simulated function RealizeSelected(optional bool forceRedrawIfPreviouslySelected){}
simulated function AS_SetSelected(int TargetIndex, bool forceRedrawIfPreviouslySelected){}
simulated function AS_SetUnitHelp(string icon0, string display0, string icon1, string display1){}
simulated function AS_SetAddUnitText(int Index, string displayString, string addStringPrefix, string Icon){}
