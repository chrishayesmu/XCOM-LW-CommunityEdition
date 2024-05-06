class XComOnlineGameSettingsDeathmatchRanked extends XComOnlineGameSettingsDeathmatch
    config(MPGame);

var private config bool DEBUG_bDisableRandomMap;

defaultproperties
{
    bAllowInvites=false
    bUsesPresence=false
    bAllowJoinViaPresence=false
    OnlineStatsWriteClass=class'XComOnlineStatsWriteDeathmatchRanked'
    OnlineStatsReadClass=class'XComOnlineStatsReadDeathmatchRanked'
}