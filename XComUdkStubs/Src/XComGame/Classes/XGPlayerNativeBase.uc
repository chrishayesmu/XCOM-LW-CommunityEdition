class XGPlayerNativeBase extends Actor
    native(Core)
    notplaceable
    hidecategories(Navigation);

struct native XGPlayer_TurnRepData
{
    var int m_iTurn;
    var XGUnit m_kActiveUnit;
    var bool m_bActiveUnitNone;
};

var XComTacticalController m_kPlayerController;
var protected repnotify repretry XGPlayer_TurnRepData m_kBeginTurnRepData;
var protected repnotify repretry XGPlayer_TurnRepData m_kEndTurnRepData;
var protected bool m_bClientCheckForEndTurn;
var XGSightManagerNativeBase m_kSightMgrBase;