class UIFxsMovieMgr extends Object
    native(UI);
//complete stub
var float MOUSE_DOUBLE_CLICK_SPEED;
var array<UIFxsMovie> movies;
var private Actor m_pPres;
var private bool m_bShowingDebugAnchorFrame;
var bool m_bDebugHardHide;
var bool m_bVisible;
var bool m_bHasVisiblBeenToggled;
var bool m_bIsInputGateRaised;
var UIFxsLocalizationHelper m_kLocHelper;
var array<UI_FxsScreen> m_arrScreenInputStack;
var TextureRenderTarget2D m_kUIDisplayTarget;
var UITutorialSaveData TutorialSaveData;

simulated function Init(Actor PRES){}
simulated event Destroyed();

simulated function bool OnInput(int iInput, optional int Actionmask=1){}
simulated function bool IsFirstInput(UI_FxsScreen screen){}
simulated function UI_FxsScreen GetFirstInputScreen(){}
simulated function InitMovie(UIFxsMovie kMovie){}
simulated function RemoveMovie(UIFxsMovie kMovie){}
simulated function Show(){}
simulated function Hide(){}
simulated function bool IsVisible(){}
simulated function UIToggleAnchors();
simulated function UIToggleHardHide(){}
simulated function PrintCurrentMovies();
simulated function PrintInputStack();
function PushScreen(UI_FxsScreen screen){}
function PopFirstInstanceOfScreen(UI_FxsScreen screen){}
simulated function bool IsInited(){}

