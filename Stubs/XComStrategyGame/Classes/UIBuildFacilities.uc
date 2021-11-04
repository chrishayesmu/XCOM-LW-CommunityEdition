class UIBuildFacilities extends UI_FxsShellScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub
var const localized string m_strBuildFacilityTitle;
var int m_iView;
var XGBuildUI m_kLocalMgr;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGBuildUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
final function SetCursorAt(string targetClip){}
simulated function OnUAccept(){}
simulated function OnUCancel(){}
simulated function UpdateData(){}
simulated function UpdateResources(){}
final simulated function AS_UpdateFacilityCard(float xloc, float yloc, string sName, string Icon, bool bDisabled, bool bAdjacencyBonusLeft, bool bAdjacencyBonusTop){}
simulated function UpdateCursor(){}
final simulated function AS_SetCursor(float xloc, float yloc, string DisplayText, int iUIState){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function GoToView(int iView){}
simulated function AS_SetTitle(string displayString){}
function UnlockItems(array<TItemUnlock> arrUnlocks){}
function UnlockItem(TItemUnlock kUnlock);
simulated function Remove(){}
event Destroyed(){}