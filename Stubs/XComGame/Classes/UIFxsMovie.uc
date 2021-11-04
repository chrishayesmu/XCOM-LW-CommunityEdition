class UIFxsMovie extends GFxMoviePlayer
    native(UI)
    config(UI)
	dependson(UI_FxsPanel);
//complete  stub

var protected string m_sMCPath;
var protected bool b_IsVisible;
var protected bool b_IsInitialized;
var bool m_bIsFullScreenViewport;
var bool m_bMouseIsActive;
var bool m_bShowingDebugAnchorFrame;
var bool m_bDebugHardHide;
var bool m_bTouchEnabled;
var Object m_kExternalCommandHandler;
var int UIMGR_RES_X;
var int UIMGR_RES_Y;
var Vector2D m_v2ScaledOrigin;
var Vector2D m_v2ScaledDimension;
var Vector2D m_v2ScaledFullscreenDimension;
var Vector2D m_v2FullscreenDimension;
var Vector2D m_v2ViewportDimension;
var UIFxsMovieMgr movieMgr;
var array<UI_FxsScreen> screens;
var name s_mainClip;
var int m_bShowingModal;
var Actor m_pPres;
var private EConsoleType m_eConsoleType;
var array<UI_FxsScreen> m_arrHighestDepthScreens;
var array<UI_FxsScreen> m_arrScreensHiddenBeforeCinematics;

simulated function SetFSCommand(){}
simulated function bool IsInited(){}
simulated function bool IsVisible(){}
simulated function string GetMainClip(){}
simulated function SetMovieMgr(UIFxsMovieMgr _movieMgr){}
simulated function InitMovie(Actor _pres){}
simulated function OnInit(){}
simulated function OnClose(){}
simulated event Destroyed(){}
simulated function ConvertUIToUVCoords(out Vector2D kVector){}
simulated function GetGammaLogoDimensions(out Vector2D TopLeft, out Vector2D Extent){}
simulated function GetScreenDimensions(out int RenderedSizeWidth, out int RenderedSizeHeight, out float RenderedAspectRatio, out int FullSizeWidth, out int FullSizeHeight, out float FullAspectRatio, out int AlreadyAdjustedVerticalSafeZone);
simulated function SetResolutionAndSafeArea(){}
simulated function WatchForFullscreenChanges(){}
simulated function SetDoubleClickMouseSpeed(){}
simulated function SetHitTestDisable(bool bShouldDisable){}
simulated function bool OnUnrealCommand(int iInput, optional int Actionmask=1){}
simulated function LoadScreen(UI_FxsScreen screen){}
simulated function RemoveScreen(UI_FxsScreen screen){}
simulated function InsertScreenInstance(UI_FxsScreen screen, name screenid){}
simulated function RemoveScreenInstance(UI_FxsScreen screen){}
simulated function bool IsScreenFirstToReceiveInput(UI_FxsScreen screen){}
simulated function PrintScreenInputStack(){}
simulated function RaiseInputGate(){}
simulated function LowerInputGate(){}
simulated function bool IsShowingModal(){}
native simulated function name GetMCPath();
native simulated function Actor GetActor();
simulated function Show(optional bool bShowAllScreens=true){}
simulated function ShowAllScreens(){}
simulated function Hide(optional bool bHideAllScreens=true){}
simulated function HideAllScreens(){}
simulated function Vector2D GetScreenResolution(){}
simulated function Vector2D GetUIResolution(){}
static function string ColorString(string StrValue, Color clrNewColor){}
function int ToFlashAlpha(Color kColor){}
function string ToFlashHex(Color kColor){}
static function Color CreateColor(EWidgetColor eColor, optional EColorShade eShade){}
simulated function Vector2D ConvertNormalizedUICoordsToScreenCoords(float X, float Y){}
simulated function Vector2D ConvertUVToUICoords(Vector2D kInVector){}
function float ConvertFloatToPixel(float Percent, string typeOfCoord){}
native simulated function ClearModal();
simulated function UIToggleAnchors(){}
simulated function UIToggleHardHide(){}
simulated function PrintCurrentScreens();
simulated function FlashRaiseInit(string Path){}
simulated function FlashRaiseCommand(string Path, string Cmd, string Arg){}
simulated function FlashRaiseMouseEvent(string Path, int Cmd, string Arg){}
function bool IsMouseActive(){}
simulated function SetMouseActive(bool bActive){}
simulated function ActivateMouse(){}
simulated function DeactivateMouse(){}
simulated function ToggleMouseActive(){}
final function NotifyFlashMouseStateChange(){}
function bool IsTouchEnabled(){}
simulated function EnableTouch(){}
simulated function DisableTouch(){}
private final function NotifyTouchStateChange(){}
simulated function UpdateHighestDepthScreens(){}
private final simulated function MoveScreenToTop(name strScreenName){}
simulated function AS_ToggleMouseHitDebugging(){}
simulated function UpdateLanguage(){}
simulated function HideUIForCinematics(){}
simulated function ShowUIForCinematics(){}
simulated function bool IsScreenHiddenForCinematic(UI_FxsScreen screen){}
