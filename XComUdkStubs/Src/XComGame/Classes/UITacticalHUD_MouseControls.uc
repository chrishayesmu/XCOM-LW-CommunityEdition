class UITacticalHUD_MouseControls extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

struct TButtonItems
{
    var string Label;
    var string Key;
    var XGTacticalScreenMgr.EUIState uistate;
};

var const localized string m_strPrevSoldier;
var const localized string m_strNextSoldier;
var const localized string m_strSoldierInfo;
var const localized string m_strEndTurn;
var const localized string m_strNoKeyBoundString;
var const localized string m_strCancelShot;
var const localized string m_strShotInfo;
var protected int m_optEndTurn;
var protected int m_optPrevSoldier;
var protected int m_optNextSoldier;
var protected int m_optSoldierInfo;
var protected int m_optRotateCameraLeft;
var protected int m_optRotateCameraRight;
var protected int m_optCancelShot;
var protected int m_optShotInfo;
var private int m_iCurrentSelection;
var protected Color m_clrBad;
var array<TButtonItems> ButtonItems;
var protected int m_optPause;
var protected int m_optCursorUpTouch;
var protected int m_optCursorDownTouch;
var private bool m_bMoveButtonVisible;
var private bool m_bPauseOnly;

defaultproperties
{
    m_optPrevSoldier=2
    m_optNextSoldier=3
    m_optSoldierInfo=1
    m_optRotateCameraLeft=4
    m_optRotateCameraRight=5
    m_optShotInfo=1
    m_clrBad=(R=200,G=0,B=0,A=175)
    m_optPause=8
    m_optCursorUpTouch=6
    m_optCursorDownTouch=7
    s_name="mouseControlsMC"
}