class UITargetingReticle extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

var Vector2D Loc;
var private bool m_bLockTheCursor;
var private bool m_bUpdateShotWithLoc;
var private bool m_bShotIsBlocked;
var private XGUnit m_kTargetedUnit;
var private int m_id;
var int m_iWatchVar_UpdateShotData;
var const localized string m_strShotIsBlocked;