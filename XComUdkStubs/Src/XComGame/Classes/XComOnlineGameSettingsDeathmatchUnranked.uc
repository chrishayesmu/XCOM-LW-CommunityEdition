class XComOnlineGameSettingsDeathmatchUnranked extends XComOnlineGameSettingsDeathmatch
    config(MPGame);

defaultproperties
{
    OnlineStatsWriteClass=class'XComOnlineStatsWriteDeathmatchUnranked'
    OnlineStatsReadClass=class'XComOnlineStatsReadDeathmatchUnranked'
    // Properties=/* Array type was not detected. */
}