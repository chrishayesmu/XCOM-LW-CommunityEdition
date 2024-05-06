class XGAction_DropDown extends XGAction
    notplaceable
    hidecategories(Navigation);

enum eDDWaitStatus
{
    eDDWS_Begin,
    eDDWS_ClimbDownAnim,
    eDDWS_ClimbOverAnim,
    eDDWS_ClimbOverStopAnim,
    eDDWS_SpawnedAlien,
    eDDWS_Done,
    eDDWS_MAX
};

struct InitialReplicationData_XGAction_DropDown
{
    var Vector m_vDestination;
    var float m_fDistance;
    var bool m_ForceReplication;
};

var Vector m_vDestination;
var float m_fDistance;
var bool bClimbOver;
var bool bSpawnedAlien;
var bool bOverwatchWhenDone;
var bool bStoredSkipIK;
var bool m_bSpawnAlienQueueDone;
var private bool m_bInitialReplicationDataReceived_XGAction_DropDown;
var float fPawnHalfHeight;
var XComSpawnPoint_Alien kSpawnPoint;
var int iAttackChanceWhenDone;
var int StartAnim;
var int StopAnim;
var int m_iAimingIterations;
var private repnotify InitialReplicationData_XGAction_DropDown m_kInitialReplicationData_XGAction_DropDown;
var AnimNodeSequence ActiveAnimSeq;
var XGAction_DropDown.eDDWaitStatus m_eDDWaitStatus;

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
}