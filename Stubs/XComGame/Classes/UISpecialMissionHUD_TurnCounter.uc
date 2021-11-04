class UISpecialMissionHUD_TurnCounter extends UI_FxsPanel
	notplaceable
	hidecategories(Navigation);
//complete stub

var int m_iState;
var string m_sLabel;
var string m_sSubLabel;
var string m_sCounter;
var bool m_bLocked;
var bool m_bExpired;
var bool m_bInfinity;
var int m_iCounter;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function SetUIState(int iState, optional bool forceUIUpdate=FALSE){}
simulated function SetLabel(string sLabel, optional bool forceUIUpdate=FALSE){}
simulated function SetSubLabel(string sSubLabel, optional bool forceUIUpdate=FALSE){}
simulated function SetCounter(string sCounter, optional bool forceUIUpdate=FALSE){}
simulated function ExpireCounter(optional bool forceUIUpdate=FALSE){}
simulated function ShowInfinity(optional bool forceUIUpdate=FALSE){}
simulated function LockCounter(optional bool forceUIUpdate=FALSE){}
simulated function UnlockCounter(optional bool forceUIUpdate=FALSE){}
function AS_SetColor(string newColor){}
function AS_SetLabel(string NewLabel){}
function AS_SetSubLabel(string newSubLabel){}
function AS_SetCounter(string newCount){}
