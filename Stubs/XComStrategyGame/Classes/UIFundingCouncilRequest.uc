class UIFundingCouncilRequest extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

const NUM_BUTTONS = 2;

var IFCRequestInterface m_kDataInterface;
var TFCRequest m_kCachedRequestData;
var XGPendingRequestsUI m_kLocalMgr;
var int m_iSelectedBtn;
var EFCRequestType m_eRequestType;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, IFCRequestInterface kDataInterface, optional EFCRequestType eType){}
simulated function XGPendingRequestsUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function ShowRequest(){}
function ShowRequestComplete(){}
function string BuildRewardsString(optional bool requestCompleted){}
simulated function bool OnAccept(optional string Arg){}
function RealizeSelected(int newSelection){}
simulated function bool OnCancel(optional string Arg){}
simulated function GoToView(int iView);
simulated function AS_OpenRequestCompleteDialog(string Title, string subtitle, string Description, string rewards, string buttonLabel){}
simulated function AS_SetSalesRequestImage(string imgPath, float imgScale){}
simulated function AS_SetButtonData(int buttonIndex, string Text, bool Disabled){}
simulated function AS_SetButtonFocus(int buttonIndex, bool bFocus){}
simulated function Remove(){}

state Main{
    simulated function bool OnUnrealCommand(int Cmd, int Arg){}
    simulated function bool OnMouseEvent(int Cmd, array<string> args){}
}

state RequestComplete{
    simulated function bool OnUnrealCommand(int Cmd, int Arg){}
    simulated function bool OnMouseEvent(int Cmd, array<string> args){}
    simulated function CloseScreen(){}
}