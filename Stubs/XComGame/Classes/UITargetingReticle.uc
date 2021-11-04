class UITargetingReticle extends UI_FxsPanel;
// complete stub

var Vector2D Loc;
var private bool m_bLockTheCursor;
var private bool m_bUpdateShotWithLoc;
var private bool m_bShotIsBlocked;
var private XGUnit m_kTargetedUnit;
var private int m_id;
var int m_iWatchVar_UpdateShotData;
var const localized string m_strShotIsBlocked;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, int _id, XGUnit _targetedUnit){}
simulated function OnInit(){}
simulated function UpdateShotData(){}
simulated function UpdateLocation(){}
simulated function SetLoc(float X, float Y){}
simulated function LockTheCursor(bool bShouldLock){}
simulated function SetAimPercentages(float fPercent, float fCritical){}
simulated function SetCursorMessage(string MessageText){}
simulated function SetBlankCursorMessage(){}
simulated function SetLockedOn(bool isLockedOn){}
simulated function SetDisabled(bool IsDisabled){}
simulated function Remove(){}
