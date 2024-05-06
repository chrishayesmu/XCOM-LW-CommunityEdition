class UIFxsMovie extends GFxMoviePlayer
    native(UI)
    config(UI);

var protected string m_sMCPath;
var protected bool b_IsVisible;
var protected bool b_IsInitialized;
var bool m_bIsFullScreenViewport;
var private bool m_bMouseIsActive;
var private bool m_bShowingDebugAnchorFrame;
var bool m_bDebugHardHide;
var private bool m_bTouchEnabled;
var Object m_kExternalCommandHandler;
var int UIMGR_RES_X;
var int UIMGR_RES_Y;
var Vector2D m_v2ScaledOrigin;
var Vector2D m_v2ScaledDimension;
var Vector2D m_v2ScaledFullscreenDimension;
var Vector2D m_v2FullscreenDimension;
var Vector2D m_v2ViewportDimension;
var privatewrite UIFxsMovieMgr movieMgr;
var array<UI_FxsScreen> screens;
var private name s_mainClip;
var private int m_bShowingModal;
var protected Actor m_pPres;
var private EConsoleType m_eConsoleType;
var array<UI_FxsScreen> m_arrHighestDepthScreens;
var array<UI_FxsScreen> m_arrScreensHiddenBeforeCinematics;

defaultproperties
{
    UIMGR_RES_X=1280
    UIMGR_RES_Y=720
    s_mainClip="_level0.theInterfaceMgr"
    MovieInfo=SwfMovie'gfxInterfaceMgr.interfaceMgr'
}