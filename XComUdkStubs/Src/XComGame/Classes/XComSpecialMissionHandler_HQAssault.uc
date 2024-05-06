class XComSpecialMissionHandler_HQAssault extends XComSpecialMissionHandler
    notplaceable
    hidecategories(Navigation);

const SPAWN_TIMEOUT = 10.0f;

enum ERequestStep
{
    eStep_Unknown,
    eStep_Appearance,
    eStep_Inventory,
    eStep_Perks,
    eStep_Finished,
    eStep_MAX
};

struct PendingTraversal
{
    var XGUnit m_kUnit;
    var XComSpawnPoint m_kSpawnPt;
    var Vector m_vSpawnLoc;
};

struct CheckpointRecord_XComSpecialMissionHandler_HQAssault extends CheckpointRecord
{
    var array<TTransferSoldier> m_arrReinforcements;
};

var array<TTransferSoldier> m_arrReinforcements;
var private int m_iCurrentSoldierContent;
var private bool m_bThrowawayContent;
var private array<PendingTraversal> m_arrTraversals;
var private array<PendingTraversal> m_arrSpawningUnits;
var private float m_fSpawnWaitTime;
var private array<TSoldierPawnContent> m_arrContentToBurn;
var private array<Object> m_arrContent;
var private ERequestStep m_eRequestStep;