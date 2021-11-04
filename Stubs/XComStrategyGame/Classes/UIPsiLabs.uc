class UIPsiLabs extends UISoldierSlots
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var int m_iView;
var XGPsiLabsUI m_kLocalMgr;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function XGPsiLabsUI GetMgr(){}
simulated function GoToView(int iView){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
final simulated function UpdateSlots(TPsiTraineeList kTraineeList){}
final simulated function UpdateResults(TPsiResultsList kResultsList){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function bool OnOption(optional string Arg){}
simulated function Remove(){}
simulated function OnReceiveFocus(){}
