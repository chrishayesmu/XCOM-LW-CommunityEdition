class UITacticalHUD_MouseControls extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation)
	dependson(XGTacticalScreenMgr);
//complete stub

struct TButtonItems
{
    var string Label;
    var string Key;
    var EUIState uistate;
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

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function UpdateControls(optional bool bPauseButtonOnly){}
simulated function SetButtonItem(int Index, string Label, string Key, EUIState uistate){}
simulated function SetButtonState(int Index, EUIState uistate){}
simulated function UpdateMoveButton(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(){}
simulated function string GetIconLabelForIndex(int Index){}
simulated function Hide(){}
event Destroyed(){}
simulated function AS_SetNumActiveControls(int numActive){}
simulated function AS_HideAllButOne(int VisibleIndex){}
simulated function AS_SetIconButton(int Index, string Label, string hotKey, string iconLabel, bool Enabled){}
simulated function AS_SetHoverHelp(string Label){}
simulated function AS_SetMoveButtonData(string Label){}
