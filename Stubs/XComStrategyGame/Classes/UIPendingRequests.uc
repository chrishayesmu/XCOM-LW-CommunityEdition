class UIPendingRequests extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var const localized string m_strBack;
var const localized string m_strPendingRequests;
var const localized string m_strFunding;
var const localized string m_strMissions;
var const localized string m_strViewRequest;
var const localized string m_strHoursLeft;
var const localized string m_strSatelliteTransferLabel;
var const localized string m_strNoPendingRequests;
var const localized string m_strStatus_OperationInProgress;
var const localized string m_strStatus_TransferComplete;
var const localized string m_strStatus_AwaitingJetTransfer;
var const localized string m_strStatus_SatelliteEnRoute;
var const localized string m_strStatus_SatelliteCoverageComplete;
var const localized string m_strStatus_AwaitingSatelliteCoverage;
var const localized string m_strStatus_CanNotComplete;
var const localized string m_strStatus_CanComplete;
var int m_iView;
var array<int> m_arrSelectableIndexes;
var XGPendingRequestsUI m_kLocalMgr;

function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGPendingRequestsUI GetMgr(optional int iStaringView){}
simulated function OnInit(){}
function UpdateData(){}
function XGFacility_Hangar HANGAR(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function bool OnPressUp(){}
simulated function bool OnPressDown(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
function GoToView(int iView){}
simulated function bool IsVisible(){}
simulated function Hide(){}
simulated function Show(){}
event Destroyed(){}
simulated function AS_Clear(){}
simulated function AS_SetLabels(string pendingRequests, string funding, string Missions, string viewRequest, string dismiss){}
simulated function AS_AddFundingRequest(int Index, string Text, string statusText, string timeLeftText, bool isDoable, bool isInProgress, bool IsComplete){}
simulated function AS_SetSelection(int Index){}
simulated function AS_SetNoneMessage(string msg){}
