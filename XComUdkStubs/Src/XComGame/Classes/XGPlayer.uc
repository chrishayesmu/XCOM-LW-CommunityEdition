class XGPlayer extends XGPlayerNativeBase
    native(Core)
    notplaceable
    hidecategories(Navigation);

const END_TURN_CANCEL_TARGETING_ACTIONS_TIMEOUT_SECONDS = 5.0f;

struct CheckpointRecord
{
    var XGSquad m_kSquad;
    var array<XGUnit> m_arrEnemiesSeen;
    var array<EPawnType> m_arrPawnsSeen;
    var array<int> m_arrTechHistory;
    var int m_iTurn;
    var int m_iHitCounter;
    var int m_iMissCounter;
    var int m_iNumOneShots;
    var bool m_bCantLose;
    var XGUnit m_kActiveUnit;
};

struct native PendingSpawnUnit
{
    var XGCharacter_Soldier kNewChar;
    var XComSpawnPoint kSpawnPoint;
    var int iContentRequests;
    var delegate<UnitSpawnCallback> Callback;
    var bool bVIP;
};

var XGSquad m_kSquad;
var protectedwrite array<XGUnit> m_arrEnemiesSeen;
var repnotify XGSightManager m_kSightMgr;
var protected array<EPawnType> m_arrPawnsSeen;
var protected XGUnit m_kActiveUnit;
var protected int m_iTurn;
var int m_iHitCounter;
var int m_iMissCounter;
var int m_iNumOneShots;
var bool m_bCantLose;
var protected bool m_bWaitingForNextPreviousUnitServerAck;
var protected bool m_bAcknowledgedSound;
var protected bool m_bLoadedFromCheckpoint;
var repnotify bool m_bPushStatePanicking;
var bool m_bPopStatePanicking;
var bool m_bMyTurn;
var bool m_bAbortChecked;
var bool m_bCheckForEndTurnOnLoad;
var bool m_bKismetControlledCombatMusic;
var protected int m_iClientBeginTurn;
var protected int m_iClientEndTurn;
var EPlayerEndTurnType m_ePlayerEndTurnType;
var array<int> m_arrTechHistory;
var XComUIBroadcastWorldMessage m_kBroadcastWorldMessage;
var private PendingSpawnUnit m_kPendingSpawnUnit;
var protected int m_iLoop;
var protected XGUnit m_kLoopUnit;
var privatewrite float m_fEndTurnCancelTargetingActionsTimeoutSeconds;

delegate UnitSpawnCallback(XGUnit SpawnedUnit)
{
}

defaultproperties
{
    m_iMissCounter=1
    m_eTeam=eTeam_XCom
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}