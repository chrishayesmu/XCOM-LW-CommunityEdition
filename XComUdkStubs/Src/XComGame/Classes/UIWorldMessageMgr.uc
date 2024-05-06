class UIWorldMessageMgr extends UIMessageMgrBase
    notplaceable
    hidecategories(Navigation);

const NUM_INITIAL_INACTIVE_MESSAGES = 8;
const FXS_MSG_BEHAVIOR_FLOAT = 0;
const FXS_MSG_BEHAVIOR_STEADY = 1;
const FXS_MELD_MSG_BEHAVIOR_STEADY = 2;
const FXS_MELD_MSG_BEHAVIOR_ENGAGED = 3;

struct THUDMsg
{
    var string m_sId;
    var string m_txtMsg;
    var EWidgetColor m_eColor;
    var Vector m_vLocation;
    var bool m_bVisible;
    var bool m_bIsImportantMessage;
    var int m_eBehavior;
    var float m_fVertDiff;
    var float m_fDisplayTime;
};

var const EWidgetColor DAMAGE_DISPLAY_DEFAULT_COLOR;
var const string DAMAGE_DISPLAY_DEFAULT_ID;
var const bool DAMAGE_DISPLAY_DEFAULT_USE_SCREEN_LOC_PARAM;
var const Vector2D DAMAGE_DISPLAY_DEFAULT_SCREEN_LOC;
var const float DAMAGE_DISPLAY_DEFAULT_DISPLAY_TIME;
var private float m_fVertDiff;
var private array<THUDMsg> m_arrMsgs;
var private array<int> m_arrActiveMessages;
var private array<int> m_arrInactiveMessages;

defaultproperties
{
    DAMAGE_DISPLAY_DEFAULT_COLOR=eColor_Bad
    DAMAGE_DISPLAY_DEFAULT_DISPLAY_TIME=5.0
    m_fVertDiff=0.050
    s_package="/ package/gfxWorldMessageMgr/WorldMessageMgr"
    s_screenId="gfxWorldMessageMgr"
    s_name="theWorldMessageContainer"
}