class XGAction_DropDown extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

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
var bool m_bInitialReplicationDataReceived_XGAction_DropDown;
var float fPawnHalfHeight;
var XComSpawnPoint_Alien kSpawnPoint;
var int iAttackChanceWhenDone;
var int StartAnim;
var int StopAnim;
var int m_iAimingIterations;
var repnotify InitialReplicationData_XGAction_DropDown m_kInitialReplicationData_XGAction_DropDown;
var AnimNodeSequence ActiveAnimSeq;
var eDDWaitStatus m_eDDWaitStatus;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_DropDown;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit, optional bool bSpawned, optional XComSpawnPoint_Alien SpawnPt, optional bool bOverwatch, optional int iAttackChance){}
simulated event SimulatedInit(){}
simulated function bool CanBePerformed(){}
simulated function bool GetPathingDestination(out Vector OutDestination){}
simulated function string GetDebugHangLog(){}
simulated event Destroyed(){}

simulated state Executing
{}