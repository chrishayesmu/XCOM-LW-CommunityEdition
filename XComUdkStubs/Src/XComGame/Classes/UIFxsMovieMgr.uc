class UIFxsMovieMgr extends Object
    native(UI);

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

defaultproperties
{
    MOUSE_DOUBLE_CLICK_SPEED=200.0
}