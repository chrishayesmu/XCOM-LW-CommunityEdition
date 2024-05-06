class UIMultiplayerPostMatchSummary extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var const localized string m_strMatchSummary;
var const localized string m_strGame;
var const localized string m_strPoints;
var const localized string m_strMap;
var const localized string m_strTurns;
var const localized string m_strTime;
var const localized string m_strWin;
var const localized string m_strLose;
var const localized string m_strReadyForRematch;
var const localized string m_strContinue;
var const localized string m_strRematch;
var private int m_iSelectedIndex;
var private XComMultiplayerTacticalUI m_kMPInterface;
var private UniqueNetId m_TopPlayerUniqueId;
var private UniqueNetId m_BottomPlayerUniqueId;

defaultproperties
{
    s_package="/ package/gfxMultiplayerPostMatchSummary/MultiplayerPostMatchSummary"
    s_screenId="gfxMultiplayerPostMatchSummary"
    m_bAnimateOutro=false
    e_InputState=eInputState_Consume
    b_OwnsMouseFocus=true
    s_name="theScreen"
}