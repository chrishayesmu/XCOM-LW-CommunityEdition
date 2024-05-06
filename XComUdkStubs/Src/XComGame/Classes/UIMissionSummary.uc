class UIMissionSummary extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var XGTacticalScreenMgr m_kTacMgr;
var protected string m_sMouseNavigation;
var protected UIMissionSummary_Factors m_kFactors;
var protected UIMissionSummary_Artifacts m_kArtifacts;
var protected UIMissionSummary_Promotions m_kPromotions;
var protected UIMissionSummary_Ticker m_kTicker;
var protected UI_FxsPanel m_kFocus;
var const localized string m_strContinue;

defaultproperties
{
    m_sMouseNavigation="theMouseNavigation"
    s_package="/ package/gfxMissionSummary/MissionSummary"
    s_screenId="gfxUIMissionSummary"
    m_bStopMusicOnExit=true
    m_bAnimateOutro=false
    e_InputState=eInputState_Consume
    b_OwnsMouseFocus=true
    s_name="theMissionSummary"
}