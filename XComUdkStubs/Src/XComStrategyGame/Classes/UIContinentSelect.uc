// UI class which is displayed at the start of a new game, when
// selecting which country/continent to start with
class UIContinentSelect extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);

var const localized string m_strAccept;
var XGContinentUI m_kLocalMgr;
var private int m_iContinent;
var private int maxContinents;
var private int m_iView;
var protected array<UIOption> m_arrUIOptions;

defaultproperties
{
    s_package="/ package/gfxContinentSelect/ContinentSelect"
    s_screenId="gfxContinentSelect"
    m_bAnimateOutro=false
    e_InputState=eInputState_Evaluate
    s_name=theScreen
}