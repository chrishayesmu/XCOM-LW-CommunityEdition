class XComOnlineGameSettingsDeathmatch extends XComOnlineGameSettings
    abstract
    config(MPGame);

defaultproperties
{
    NumPublicConnections=2
    OnlineStatsWriteClass=class'XComOnlineStatsWriteDeathmatch'
    OnlineStatsReadClass=class'XComOnlineStatsReadDeathmatch'
    // LocalizedSettings=/* Array type was not detected. */
    // LocalizedSettingsMappings=/* Array type was not detected. */
}