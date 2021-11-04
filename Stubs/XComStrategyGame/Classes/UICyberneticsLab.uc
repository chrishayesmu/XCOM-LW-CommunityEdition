class UICyberneticsLab extends UISoldierSlots
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var protected int m_iView;
var protected XGCyberneticsUI m_kLocalMgr;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function XGCyberneticsUI GetMgr(){}
simulated function GoToView(int iView){}
simulated function UpdateSlots(TCyberneticsSubjectList kTraineeList){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function OnReceiveFocus(){}
simulated function Remove(){}
simulated function UpdateResources(){}
