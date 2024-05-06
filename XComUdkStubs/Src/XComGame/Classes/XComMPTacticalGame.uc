class XComMPTacticalGame extends XComTacticalGame
    config(MPGame)
    hidecategories(Navigation,Movement,Collision);

const MAX_FAILED_STAT_READS_UNTIL_RANKED_GAME_DISCONNECT = 4;

var int m_iRequiredPlayers;
var protectedwrite int m_iMaxTurnTimeSeconds;
var protectedwrite bool m_bMatchStarting;
var privatewrite bool m_bPendingMatchTimedOut;
var privatewrite bool m_bDisconnectedBecauseLogoutsBeforeGameStart;
var privatewrite bool m_bSeamlessTravelled;
var privatewrite bool m_bPingingMCP;
var privatewrite bool m_bHasWorldCleanedUp;
var XComOnlineStatsRead m_kStatsRead;
var config float m_fPendingMatchTimeoutSeconds;
var privatewrite float m_fPendingMatchTimeoutCounter;
var privatewrite XComMPTacticalController m_kPlayerLoggingOut;
var privatewrite XComMPTacticalController m_kLocalPlayer;
var privatewrite XComMPTacticalController m_kOpponentPlayer;

defaultproperties
{
    m_iRequiredPlayers=2
    PlayerControllerClass=class'XComMPTacticalController'
    PlayerReplicationInfoClass=class'XComMPTacticalPRI'
    GameReplicationInfoClass=class'XComMPTacticalGRI'
}