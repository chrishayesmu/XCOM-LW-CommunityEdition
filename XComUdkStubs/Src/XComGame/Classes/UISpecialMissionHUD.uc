class UISpecialMissionHUD extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var UISpecialMissionHUD_Arrows m_kArrows;
var UISpecialMissionHUD_MeldStats m_kMeldStats;
var UISpecialMissionHUD_CapturePointStats m_kCapturePointStats;
var UISpecialMissionHUD_BombMessage m_kBombMessage;
var UISpecialMissionHUD_TurnCounter m_kGenericTurnCounter;
var string s_TurnCountersContainer;
var const localized string m_strExtractionsTitle;
var const localized string m_strExtractionsBody;
var const localized string m_strHiveTitle;
var const localized string m_strHiveBody;

defaultproperties
{
    s_TurnCountersContainer="counters"
    s_package="/ package/gfxSpecialMissionHUD/SpecialMissionHUD"
    s_screenId="gfxSpecialMissionHUD"
    s_name="theSpecialMissionHUD"
}