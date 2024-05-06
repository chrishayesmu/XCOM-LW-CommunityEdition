class UIMultiplayerPlayerStats extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var const localized string m_strPlayerStats;
var const localized string m_strWins;
var const localized string m_strLosses;
var const localized string m_strDisconnects;
var const localized string m_strFavoriteUnit;
var const localized string m_strTotalDamageDone;
var const localized string m_strTotalDamageTaken;
var const localized string m_strUnitWithMostKills;
var const localized string m_strUnitWithMostDamage;
var const localized string m_strFavoriteMap;
var const localized string m_strFavoriteAbility;
var const localized string m_strBack;
var XGPlayer m_kPlayer;
var private bool m_bShowBackButton;
var private XComMultiplayerUI m_kMPInterface;

defaultproperties
{
    s_package="/ package/gfxMultiplayerPlayerStats/MultiplayerPlayerStats"
    s_screenId="gfxMultiplayerPlayerStats"
    e_InputState=eInputState_Consume
    s_name="thePlayerStatsScreen"
}