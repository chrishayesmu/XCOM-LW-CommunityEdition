class UI_FxsScreen extends UI_FxsPanel
    native(UI)
    notplaceable
    hidecategories(Navigation);

enum EUIInputState
{
    eInputState_None,
    eInputState_Evaluate,
    eInputState_Consume,
    eInputState_ConsumeAndIgnore,
    eInputState_MAX
};

struct Menu
{
    var int iSelection;
    var int iMaxLabels;
    var int iMaxIndexes;
    var array<string> aLabels;
    var array<int> aLookupValues;
    var array<int> aIndexes;
};

var protected name s_package;
var protected name s_screenId;
var protected name MCPath;
var protected bool m_bStopMusicOnExit;
var protected bool m_bAllowShowDuringCinematic;
var protected bool m_bPreCinematicVisible;
var protectedwrite bool m_bAnimateIntro;
var protectedwrite bool m_bAnimateOutro;
var protectedwrite bool m_bDelayRemove;
var protected int m_watchVar_OnCinematicMode;
var array<UI_FxsPanel> panels;
var protected EUIInputState e_InputState;

defaultproperties
{
    s_package="<UI_FxsScreen package NOT SET>"
    s_screenId="<UI_FXsScreen id NOT SET>"
    m_bAnimateIntro=true
    m_bAnimateOutro=true
    m_watchVar_OnCinematicMode=-1
}