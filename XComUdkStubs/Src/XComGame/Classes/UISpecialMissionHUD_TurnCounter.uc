class UISpecialMissionHUD_TurnCounter extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

var int m_iState;
var string m_sLabel;
var string m_sSubLabel;
var string m_sCounter;
var bool m_bLocked;
var bool m_bExpired;
var bool m_bInfinity;
var protectedwrite int m_iCounter;

defaultproperties
{
    m_iState=-1
    s_name="counters.counter1"
}