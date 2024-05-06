class XGPlayer_MP extends XGPlayer
    notplaceable
    hidecategories(Navigation);

const WAITING_FOR_GAME_OVER_TIMEOUT_SECONDS = 7.0f;

var privatewrite bool m_bGameOver;
var privatewrite float m_fWaitingForGameOverTimerSeconds;

defaultproperties
{
    m_fWaitingForGameOverTimerSeconds=7.0
}