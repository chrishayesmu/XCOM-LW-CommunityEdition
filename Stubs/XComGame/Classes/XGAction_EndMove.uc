class XGAction_EndMove extends XGAction
    native(Action)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct native InitialReplicationData_XGAction_EndMove
{
    var bool m_bForceReplicate;
    var bool m_bNoCost;
    var bool m_bFlying;
    var Vector m_vDirectMoveDestination;
    var bool m_bPreviousIsMoveDirect;
};

var bool m_bNoCost;
var bool m_bFlying;
var bool m_bPreviousIsMoveDirect;
var bool m_bInitialReplicationDataReceived_XGAction_EndMove;
var bool m_bSpawnedAlien;
var bool m_bOverwatchWhenDone;
var bool m_bSpawnAlienQueueDone;
var bool m_bPodActivatedDuringMove;
var bool m_bIsLaunch;
var Vector m_vDirectMoveDestination;
var Vector m_vFinalRotation;
var XComCoverPoint CoverPointToClaim;
var ECoverState PredictedCoverState;
var AnimNodeSequence SeqToPlay;
var float m_fTemp;
var Rotator TargetRotator;
var Rotator StartingRotator;
var float AnimStartTime;
var float SequencePlaybackLength;
var float SmoothRotationTime;
var Vector TempLocation;
var int m_iActionHangDebugging;
var repnotify InitialReplicationData_XGAction_EndMove m_kInitialReplicationData_XGAction_EndMove;
var XComUIBroadcastWorldMessage_HoverFuel m_kBroadcastHoverFuelMessage;
var XGUnit m_kTarget;
var int m_iDamage;
var XComSpawnPoint_Alien m_kSpawnPoint;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_EndMove;

    if(bNetDirty && Role == ROLE_Authority)
        PredictedCoverState;
}

simulated event Destroyed(){}
simulated function NetForceDestroy(){}
simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit, optional bool bNoCost=false, optional bool bFlying=false, optional bool bSpawnedAlienWalkIn=false, optional bool bIsLaunch=false){}
function InitWalkIn(XComSpawnPoint_Alien SpawnPt, bool bOverwatch){}
simulated event SimulatedInit(){}
simulated function bool CanBePerformed(){}
function bool EarnedFreeMove(){}
simulated function AddRevealedEnemy(XGUnit kEnemy, EEnemyReveal eRevealType){}
simulated function RemoveFromReveal(array<XGUnit> arrUnit){}
simulated function ClearCover(){}
simulated function InternalCompleteAction(){}
simulated function bool HasDoorsOpening(){}

simulated state Executing
{
    simulated event Tick(float fDeltaT){super.Tick(fDeltaT);}
}
