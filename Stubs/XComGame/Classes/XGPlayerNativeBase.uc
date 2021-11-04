class XGPlayerNativeBase extends Actor
    native(Core)
    notplaceable;
//complete stub

struct native XGPlayer_TurnRepData
{
    var int m_iTurn;
    var XGUnit m_kActiveUnit;
    var bool m_bActiveUnitNone;

    structdefaultproperties
    {
        m_iTurn=0
        m_kActiveUnit=none
        m_bActiveUnitNone=false
    }
};
var XComTacticalController m_kPlayerController;
var repnotify XGPlayer_TurnRepData m_kBeginTurnRepData;
var repnotify XGPlayer_TurnRepData m_kEndTurnRepData;
var bool m_bClientCheckForEndTurn;
var XGSightManagerNativeBase m_kSightMgrBase;

static final function string XGPlayer_TurnRepData_ToString(const out XGPlayer_TurnRepData kTurnRepData){}
simulated event bool FromNativeCheckForEndTurn(XGUnitNativeBase kUnit){}
simulated function bool CheckForEndTurn(XGUnit kUnit);

// Export UXGPlayerNativeBase::execIsEnemy(FFrame&, void* const)
native simulated function bool IsEnemy(XGPlayerNativeBase kOtherPlayer);

// Export UXGPlayerNativeBase::execIsHumanPlayer(FFrame&, void* const)
native simulated function bool IsHumanPlayer();

simulated function XGUnit GetActiveUnit();

event XGSquadNativeBase GetNativeSquad();

event XGSquadNativeBase GetEnemySquad();