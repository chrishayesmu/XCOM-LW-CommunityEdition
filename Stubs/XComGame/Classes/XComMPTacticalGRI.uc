class XComMPTacticalGRI extends XComTacticalGRI
    config(Game)
    hidecategories(Navigation,Movement,Collision)
	dependsOn(XComMPData);
//complete  stub

var protected repnotify XGPlayer m_kActivePlayer;
var repnotify XGPlayer m_kWinningPlayer;
var XGPlayer m_kLosingPlayer;
var XComMPTacticalPRI m_kWinningPRI;
var XComMPTacticalPRI m_kLosingPRI;
var XComMPData.EMPNetworkType m_eNetworkType;
var XComMPData.EMPGameType m_eGameType;
var int m_iMapIndex;
var int m_iTurnTimeSeconds;
var int m_iMaxSquadCost;
var bool m_bIsRanked;
var repnotify bool m_bHasBubonic;
var bool m_bGameForfeited;
var bool m_bGameDisconnected;

simulated event ReplicatedEvent(name VarName){}
simulated event PostBeginPlay(){}
simulated function bool IsInitialReplicationComplete(){}
simulated function StartMatch(){}
function InitBattle(){}
simulated function SetActivePlayer(XGPlayer kActivePlayer){}
simulated function string GetMapDisplayName(){}
