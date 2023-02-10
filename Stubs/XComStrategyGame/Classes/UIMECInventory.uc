class UIMECInventory extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

enum EUIWidgetIndices_MapList
{
    eWidgetIndex_BuildNewMec,
    eWidgetIndex_MecList,
    eWidgetIndex_MAX
};

var const localized string m_strMECInventoryTitle;
var const localized string m_strMECInventorySubTitle;
var const localized string m_strButtonUpgrade;
var const localized string m_strButtonRepair;
var const localized string m_strButtonBuild;
var const localized string m_strDescBuildNewMec;
var const localized string m_strMECEquipped;
var const localized string m_strMECUnequipped;
var const localized string m_sKeysToMecDeploymentTitle;
var const localized string m_sKeysToMecDeploymentDescription;
var XGCyberneticsUI m_kLocalMgr;
var string m_strCameraTag;
var name DisplayTag;
var int m_iCurrentSelection;
var UIWidgetHelper m_hWidgetHelper;
var int m_iView;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGCyberneticsUI GetMgr(){}
simulated function OnInit(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
protected simulated function UpdateData(){}
simulated function ResetSelection(optional bool bSelectMecList){}
simulated function GoToView(int iView){}
simulated function OnBuildNewMec(){}
simulated function OnListSelection(){}
simulated function OnListSelectionChanged(int NewIndex){}
simulated function OnUCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function UpdateWidgetSelection(optional bool bUpdateInfoPanel){}
simulated function UpdateInfoPanelData(){}
simulated function string GetCosts(TUIMECInventoryItem kMec){}
simulated function ShowKeysToMecDeployment(){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
simulated function Remove(){}
simulated function UpdateResources(){}
simulated function AS_UpdateInfo(string sName, string Cost, optional string abilityInfo0, optional string abilityInfo1, optional string abilityInfo2){}
simulated function AS_SetTitle(string displayString){}
simulated function AS_SetSubTitle(string displayString){}
simulated function AS_SetBuildInfo(string displayString){}
simulated function AS_AddOption(int iIndex, string sLabel, int iState){}
simulated function AS_SetConfirmButtonHelp(string sLabel){}
simulated function AS_SetBuildButtonHelp(string sLabel, string sCost){}
simulated function AS_SetSoldier(string sName, string sStatus){}
