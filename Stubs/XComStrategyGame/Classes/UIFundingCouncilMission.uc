class UIFundingCouncilMission extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

const NUM_BUTTONS = 2;

var XGSituationRoomUI m_kLocalMgr;
var protected int m_iSelectedBtn;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager){}
simulated function XGSituationRoomUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function UpdateData(){}
function RealizeSelected(int newSelection){}
simulated function OnLoseFocus(){}
simulated function OnReceiveFocus(){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function GoToView(int iView);
function AS_OpenMissionRequest(string Title, string subtitle, string DescriptionText, string reward, string topSecretLabel){}
simulated function AS_SetButtonData(int buttonIndex, string Text, optional bool Disabled){}
simulated function AS_SetButtonFocus(int buttonIndex, bool bFocus){}
simulated function Remove(){}
