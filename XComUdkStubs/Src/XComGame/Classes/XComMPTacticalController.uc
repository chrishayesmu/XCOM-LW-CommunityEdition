class XComMPTacticalController extends XComTacticalController
    config(Game)
    hidecategories(Navigation);

var privatewrite bool m_bRankedMatchStartedFlagWritten;
var privatewrite bool m_bRoundEnded;
var bool m_bConnectionFailedDuringGame;
var bool m_bReturnToMPMainMenu;
var bool m_bIsCleaningUpGame;
var bool m_bHasCleanedUpGame;
var bool m_bHasEndedSession;
var bool m_bPingingMCP;
var bool m_bAttemptedGameInvite;