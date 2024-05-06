class XGAction_EndMove extends XGAction
    native(Action)
    notplaceable
    hidecategories(Navigation);

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
var private bool m_bInitialReplicationDataReceived_XGAction_EndMove;
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
var private repnotify InitialReplicationData_XGAction_EndMove m_kInitialReplicationData_XGAction_EndMove;
var private XComUIBroadcastWorldMessage_HoverFuel m_kBroadcastHoverFuelMessage;
var XGUnit m_kTarget;
var int m_iDamage;
var XComSpawnPoint_Alien m_kSpawnPoint;

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bReplicateFinalPawnRotation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
    m_bShouldUpdateOvermind=true
}