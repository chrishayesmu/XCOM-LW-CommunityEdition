class XGAction extends Actor
    abstract
    native(Action)
    dependson(XGNetExecActionQueue)
    nativereplication
    notplaceable
    hidecategories(Navigation)
    implements(XComProjectileEventListener);

const ACTION_INVALID_ID = -1;
const CLIENT_PROXY_ACTION_INVALID_ID = -1;

enum EStopMoveType
{
    eSMT_CloseCombat,
    eSMT_Death,
    eSMT_PatrolInterrupt,
    eSMT_RevealInterrupt,
    eSMT_MAX
};

struct native CursorSetting
{
    var() MaterialInterface Material;
    var() LinearColor Color;

    structdefaultproperties
    {
        Color=(R=4.0,G=0.750,B=0.20,A=1.0)
    }
};

struct native InitialReplicationData_XGAction
{
    var XGUnitNativeBase m_kUnit;
    var XComUnitPawnNativeBase m_kPawn;
    var int m_iBoundToClientProxyID;
    var int m_iID;
    var int m_iTimeCost;
    var int m_iDefenseCost;
    var int m_iUnitMoves;
};

struct native FinalLocomotionData
{
    var Vector m_vPawnLocation;
    var Rotator m_rPawnRotation;
    var bool m_bFlipFlopForceReplicate;
};

struct native FinalReplicationData_XGAction
{
    var bool m_bActiveUnitChanged;
    var XGUnitNativeBase m_kNewActiveUnit;
    var bool m_bNewActiveUnitNone;
    var bool m_bForceReplicate;
    var Vector SYNCCHECK_vFinalPawnLocation;
    var Rotator SYNCCHECK_rFinalPawnRotation;
};

var privatewrite repnotify repretry InitialReplicationData_XGAction m_kInitialReplicationData_XGAction;
var private bool m_bInitialReplicationDataReceived_XGAction;
var private bool m_bInitialReplicationComplete;
var bool m_bAllowDuplicates;
var private bool m_bFinalLocomotionDataReceived;
var bool m_bReplicateFinalPawnLocation;
var bool m_bReplicateFinalPawnRotation;
var private bool m_bFinalReplicationDataReceived_XGAction;
var private bool m_bWaitingForFinalReplication;
var private bool m_bProcessedFinalReplication;
var bool m_bNeedsFinalReplication;
var transient bool m_bBlocksInput;
var transient bool m_bModal;
var bool m_bExecute;
var bool m_bOwnedByLocalPlayer;
var bool m_bCompleted;
var repnotify bool m_bTerminated;
var bool m_bInitdFromClientProxyAction;
var bool m_bConstantCombat;
var bool m_bInInterruptibleState;
var bool m_bProcessNetExecActionQOnInterruptible;
var bool m_bProcessNetExecActionQOnCompleteAction;
var bool m_bRequiresAccuratePositioning;
var protected repnotify bool m_bNetForceDestroy;
var protected bool m_bNetIsForceDestroyed;
var transient bool m_bDetectedSuppressionExecutionDuringThisAction;
var transient bool m_bExecutionStopsTurnTimer;
var bool m_bWaitingOnOvermind;
var bool m_bShouldUpdateOvermind;
var private repnotify FinalLocomotionData m_kFinalLocomotionData;
var private repnotify repretry FinalReplicationData_XGAction m_kFinalReplicationData_XGAction;
var transient XGUnit m_kUnit;
var transient XComUnitPawn m_kPawn;
var transient XCom3DCursor m_kCursor;
var transient XComPresentationLayer m_kPres;
var transient int m_iTimeCost;
var transient int m_iDefenseCost;
var XComTacticalController m_kPlayerControllerOwner;
var native const transient Map_Mirror m_mapPlayerControllerRefs;
var const int m_iID;
var const int m_iClientProxyID;
var const int m_iBoundToClientProxyID;
var repnotify repretry TNetExecActionQueueNode m_kNetExecActionQueueNode;

defaultproperties
{
    m_kInitialReplicationData_XGAction=(m_iBoundToClientProxyID=-1,m_iID=-1,m_iTimeCost=-1,m_iDefenseCost=-1,m_iUnitMoves=-1)
    m_bNeedsFinalReplication=true
    m_bModal=true
    m_bProcessNetExecActionQOnCompleteAction=true
    m_bExecutionStopsTurnTimer=true
    m_iID=-1
    m_iClientProxyID=-1
    m_iBoundToClientProxyID=-1
    m_kNetExecActionQueueNode=(m_bNextExecActionNone=true,m_iExecutionOrderID=-1)
    RemoteRole=ROLE_SimulatedProxy
    bHidden=true
    bAlwaysRelevant=true
}