class XComOnlineGameSearchDeathmatchRanked extends XComOnlineGameSearchDeathmatch
    config(MPGame);

var config int m_iRankedSearchRatingDelta;
var const int m_iFinalRankedSearchRatingDelta;

defaultproperties
{
    m_iFinalRankedSearchRatingDelta=2147483647
    Query=(ValueIndex=3)
    GameSettingsClass=class'XComOnlineGameSettingsDeathmatchRanked'
    // FilterQuery=(OrClauses=/* Array type was not detected. */,OrParams=/* Array type was not detected. */,EntryId=268435489,ObjectPropertyName=MP Data INI version)
}