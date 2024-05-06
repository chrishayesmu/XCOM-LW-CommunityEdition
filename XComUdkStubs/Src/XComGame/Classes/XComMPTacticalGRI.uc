class XComMPTacticalGRI extends XComTacticalGRI
    dependson(XComMPData)
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var protected repnotify XGPlayer m_kActivePlayer;
var repnotify XGPlayer m_kWinningPlayer;
var XGPlayer m_kLosingPlayer;
var XComMPTacticalPRI m_kWinningPRI;
var XComMPTacticalPRI m_kLosingPRI;
var EMPNetworkType m_eNetworkType;
var EMPGameType m_eGameType;
var int m_iMapIndex;
var int m_iTurnTimeSeconds;
var int m_iMaxSquadCost;
var bool m_bIsRanked;
var repnotify bool m_bHasBubonic;
var bool m_bGameForfeited;
var bool m_bGameDisconnected;

defaultproperties
{
    m_kPlayerClass=class'XGPlayer_MP'
    m_bOnReceivedGameClassGetNewMPINI=false
}