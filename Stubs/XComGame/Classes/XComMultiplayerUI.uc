class XComMultiplayerUI extends Actor
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EMPMainMenuOptions
{
    eMPMainMenu_Ranked,
    eMPMainMenu_QuickMatch,
    eMPMainMenu_CustomMatch,
    eMPMainMenu_Leaderboards,
    eMPMainMenu_EditSquad,
    eMPMainMenu_AcceptInvite,
    eMPMainMenu_MAX
};

var const localized string m_aMainMenuOptionStrings[EMPMainMenuOptions];
var const localized string m_strMPCustomMatchPointsValue;
var const localized string m_strCustomMatch;
var const localized string m_strPublicRanked;
var const localized string m_strPublicUnranked;
var const localized string m_strUnlimitedLabel;
var const localized string m_strViewGamerCard;
var const localized string m_strViewProfile;
var bool m_bPassedNetworkConnectivityCheck;
var bool m_bPassedOnlineConnectivityCheck;
var bool m_bPassedOnlinePlayPermissionsCheck;
var bool m_bPassedOnlineChatPermissionsCheck;
var XComPlayerController m_kControllerRef;
var XComPlayerReplicationInfo m_kPRI;


simulated function MPInit(XComPlayerController Controller){}
simulated function SetCurrentPlayer(XComPlayerReplicationInfo kPRI){}
simulated function string GetGamerName(){}
simulated function string GetWins(){}
simulated function string GetLosses(){}
simulated function string GetDisconnect(){}
simulated function string GetFavoriteUnit(){}
simulated function string GetTotalDamageDone(){}
simulated function string GetTotalDamageTaken(){}
simulated function string GetUnitWithMostKills(){}
simulated function string GetUnitWithMostDamage(){}
simulated function string GetFavoriteMap(){}
simulated function string GetFavoriteAbility(){}
