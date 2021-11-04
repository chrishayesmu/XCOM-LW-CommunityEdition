class UIEnemyArrowContainer extends UI_FxsScreen;

//complete stub
var array<XGUnit> arrCurrent;
var XGUnit m_kNextTarget;
var XGUnit m_kPrevTarget;


simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function Update(){}
simulated function UpdateVisibleEnemies(){}
simulated function UpdateAdjacentUnits(){}
simulated function SetArrow(string Id, float xloc, float yloc, float Yaw, bool bIsInRange, string sHelp){}
simulated function RemoveArrow(string Id){}
