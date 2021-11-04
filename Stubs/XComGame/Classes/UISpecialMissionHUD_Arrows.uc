class UISpecialMissionHUD_Arrows extends UI_FxsPanel
	notplaceable
	hidecategories(Navigation);
//complete stub

struct T2DArrow
{
	var string Id;
	var Vector2D Loc;
	var float rotationDegrees;
	var EUIState arrowState;
	var int arrowCounter;
};

struct T3DArrowActor
{
	var Vector Offset;
	var Actor KActor;
	var EUIState arrowState;
	var int arrowCounter;
};

var array<T3DArrowActor> arr3DArrows;
var array<T2DArrow> arr2DArrows;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function AddArrowPointingAtActor(Actor KActor, optional Vector Offset, optional EUIState arrowState=4, optional int arrowCount=-1){}
simulated function RemoveArrowPointingAtActor(Actor KActor){}
simulated function AddArrowPointingAt2D(string strUniqueID, Vector2D v2Loc, float rotationDegrees, optional EUIState arrowState=4, optional int arrowCount=-1){}
simulated function RemoveArrowPointingAt2D(string strUniqueID){}
simulated function Update(){}
simulated function Update2DArrows(){}
simulated function UpdateTargetedArrows(){}
simulated function string GetArrowColor(XGTacticalScreenMgr.EUIState arrowState){}
simulated function string GetFormattedCount(int Count, EUIState arrowState){}
simulated function SetArrow(string Id, float xloc, float yloc, float Yaw, string sColor, string sCount){}
simulated function RemoveArrow(string Id){}
