class XComMPTacticalGame extends XComTacticalGame
    config(MPGame)
    hidecategories(Navigation,Movement,Collision)
dependson(XComMCPTypes);
//complete stub

const MAX_FAILED_STAT_READS_UNTIL_RANKED_GAME_DISCONNECT = 4;

var int m_iRequiredPlayers;
var protectedwrite int m_iMaxTurnTimeSeconds;
var protectedwrite bool m_bMatchStarting;
var bool m_bPendingMatchTimedOut;
var bool m_bDisconnectedBecauseLogoutsBeforeGameStart;
var bool m_bSeamlessTravelled;
var bool m_bPingingMCP;
var bool m_bHasWorldCleanedUp;
var XComOnlineStatsRead m_kStatsRead;
var config float m_fPendingMatchTimeoutSeconds;
var float m_fPendingMatchTimeoutCounter;
var XComMPTacticalController m_kPlayerLoggingOut;
var XComMPTacticalController m_kLocalPlayer;
var XComMPTacticalController m_kOpponentPlayer;

simulated event PreBeginPlay()
{}
simulated event Destroyed()
{}
simulated event OnCleanupWorld()
{}
event InitGame(string Options, out string ErrorMessage)
{}

function InitGameReplicationInfo(){}
function GenericPlayerInitialization(Controller C){}
function StartMatch(){}
function PostStartMatch(){}
function PerformEndGameHandling(){}
function WriteRankedMatchStartedFlag(){}
function TimerWaitForOnlineGameStateToStartThenWriteStartMatchFlag(){}
function bool IsOKToWriteMatchStartedFlag(){}
event HandleSeamlessTravelPlayer(out Controller C){}
event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string ErrorMessage){}
event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage){}
function bool IsGameControllerLoggingOut(Controller Exiting){}
function Logout(Controller Exiting){}
function UpdateGameSettingsCounts(){};
function Forfeit(XComMPTacticalController kLoserPC){}
private final function CheckForDisconnectOnLogout(Controller Exiting){}
private final function OnPingMCPCompleteFinishCheckForDisconnectOnLogout(bool bWasSuccessful, XComMCPTypes.EOnlineEventType EventType){}
private final function FinishCheckForDisconnectOnLogout(bool bOtherPlayerDisconnected){}
function bool CheckForLogoutBeforeGameStartAndDisconnect(){}
function int CountHumanPlayers(){}
function EndOnlineGame(){}
function class<XComOnlineGameSettings> GetOnlineGameSettingsClass(){}
function class<OnlineStatsWrite> GetOnlineStatsWriteClass(){}
function class<OnlineStatsRead> GetOnlineStatsReadClass(){}

auto state PendingMatch
{
	event BeginState(name PreviousStateName){}
    function Tick(float fDTime){}
}

state Playing
{
    function Logout(Controller Exiting){}
}
