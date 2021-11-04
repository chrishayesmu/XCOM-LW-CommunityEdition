class UIStrategyHUD_FSM_SituationRoom extends UIStrategyHUD_FacilitySubMenu;
//complete stub

var private bool m_bAcceptsInput;
var XGSituationRoomUI m_kLocalMgr;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, int iView){}
simulated function OnInit(){}
simulated function XGSituationRoomUI GetMgr(optional int iStartView){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function OnAccept(){}
simulated function OnCancel(){}
simulated function OnMoreInfo(){}
simulated function OnReceiveFocus(){}
simulated function GoToView(int iView){}
simulated function UpdateHeader(){}
simulated function OnDeactivate(){}
