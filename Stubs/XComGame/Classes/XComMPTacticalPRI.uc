class XComMPTacticalPRI extends XComPlayerReplicationInfo
    hidecategories(Navigation,Movement,Collision)
	dependsOn(XComMPData);
//complete stub

struct TMatchEndReplicationInfo
{
    var bool m_bWinner;
    var bool m_bRanked;
    var int m_iRankedMatchesWon;
    var int m_iRankedMatchesLost;
    var int m_iNewRankedSkillRating;
    var int m_iOldOpponentsRankedSkillRating;
    var bool m_bMatchEndReplicationInfoDirty;
};

struct TRankedDeathmatchMatchStartedReplicationInfo
{
    var int m_iRankedDeathmatchMatchesWon;
    var int m_iRankedDeathmatchMatchesLost;
    var int m_iRankedDeathmatchDisconnects;
    var int m_iRankedDeathmatchSkillRating;
    var int m_iRankedDeathmatchRank;
    var bool m_bRankedDeathmatchLastMatchStarted;
    var bool m_bRankedDeathmatchReplicationInfoFlipFlop;
};

var TMPUnitLoadoutReplicationInfo m_arrUnitLoadouts[EMPNumUnitsPerSquad];
var int m_iTotalSquadCost;
var bool m_bWinner;
var bool m_bDisconnected;
var bool m_bHasBubonic;
var bool m_bRankedDeathmatchMatchStartedReplicationInfoReceived;
var string m_strLanguage;
var repnotify TMatchEndReplicationInfo m_kWonMatchReplicationInfo;
var repnotify TMatchEndReplicationInfo m_kLostMatchReplicationInfo;
var transient array<TTransferSoldier> m_arrTransferSoldiers;
var repnotify TRankedDeathmatchMatchStartedReplicationInfo m_kRankedDeathmatchMatchStartedReplicationInfo;
