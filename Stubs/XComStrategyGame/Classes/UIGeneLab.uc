class UIGeneLab extends UISoldierSlots
    hidecategories(Navigation)
    implements(IScreenMgrInterface);

var int m_iView;
var XGGeneLabUI m_kLocalMgr;
var XGStrategySoldier m_kShuttleSoldier;
var int m_iGeneLabRow;
var int m_iGeneLabCol;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function XGGeneLabUI GetMgr(){}
simulated function GoToView(int iView){}
final simulated function UpdateSlots(TGeneSubjectList kTraineeList){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function OnReceiveFocus(){}
simulated function Remove(){}
