class XGAction extends Actor
    abstract
    native(Action)
    nativereplication
    notplaceable
    hidecategories(Navigation)
    implements(XComProjectileEventListener)
	dependsOn(XGNetExecActionQueue)
	dependsOn(XGSightManagerNativeBase);
//complete stub

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

var repnotify InitialReplicationData_XGAction m_kInitialReplicationData_XGAction;
var bool m_bInitialReplicationDataReceived_XGAction;
var bool m_bInitialReplicationComplete;
var bool m_bAllowDuplicates;
var bool m_bFinalLocomotionDataReceived;
var bool m_bReplicateFinalPawnLocation;
var bool m_bReplicateFinalPawnRotation;
var bool m_bFinalReplicationDataReceived_XGAction;
var bool m_bWaitingForFinalReplication;
var bool m_bProcessedFinalReplication;
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
var repnotify bool m_bNetForceDestroy;
var bool m_bNetIsForceDestroyed;
var transient bool m_bDetectedSuppressionExecutionDuringThisAction;
var transient bool m_bExecutionStopsTurnTimer;
var bool m_bWaitingOnOvermind;
var bool m_bShouldUpdateOvermind;
var repnotify FinalLocomotionData m_kFinalLocomotionData;
var repnotify FinalReplicationData_XGAction m_kFinalReplicationData_XGAction;
var transient XGUnit m_kUnit;
var transient XComUnitPawn m_kPawn;
var transient XCom3DCursor m_kCursor;
var transient XComPresentationLayer m_kPres;
var transient int m_iTimeCost;
var transient int m_iDefenseCost;
var XComTacticalController m_kPlayerControllerOwner;
//var native const transient map<0, 0> m_mapPlayerControllerRefs;
var const int m_iID;
var const int m_iClientProxyID;
var const int m_iBoundToClientProxyID;
var repnotify TNetExecActionQueueNode m_kNetExecActionQueueNode;


// Export UXGAction::execSetID(FFrame&, void* const)
native function SetID(int iID);

// Export UXGAction::execSetBoundToClientProxyID(FFrame&, void* const)
native function SetBoundToClientProxyID(int iBoundToClientProxyID);

// Export UXGAction::execSetClientProxyID(FFrame&, void* const)
native function SetClientProxyID(int iClientProxyID);

// Export UXGAction::execNextID(FFrame&, void* const)
native static function int NextID();

// Export UXGAction::execNextClientProxyID(FFrame&, void* const)
native static function int NextClientProxyID();
simulated event ReplicatedEvent(name VarName){}
static simulated function string InitialReplicationData_XGAction_ToString(const out InitialReplicationData_XGAction kInitRepData){}
function bool HasRedRingForAI(){}
function BaseInit(XGUnit kUnit){}
simulated function NetForceDestroy(){}
simulated function bool UpdateCiviliansPostMove(){}
simulated function AddRevealedEnemy(XGUnit kEnemy, XGSightManagerNativeBase.EEnemyReveal eRevealType){}
simulated function bool EndOfActionPodInit(){}
simulated function bool EndOfActionPodUpdating(optional XGUnit kCurrUnit){}
simulated function ActivatePod(XGUnit kUnit, XGUnit kEnemy){}
simulated function bool EndOfActionOvermindInit(){}
simulated function bool EndOfActionOvermindUpdating(){}
simulated event InitFromClientProxyAction(XGAction kClientProxyAction){}
simulated event SimulatedInit(){}
simulated event bool IsInitialReplicationComplete(){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function FinalizeLocomotion(){}
simulated event bool HasReceivedFinalLocomotionData(){}
simulated function bool IsFinalReplicationComplete(){}
simulated function OnFinalReplicationComplete(){}
simulated event bool IsInterruptibleBy(class<XGAction> kActionClass){}
simulated event bool IsShuttingDown(){}
simulated function bool InternalIsInterruptibleBy(class<XGAction> kActionClass){}
simulated function Terminate(){}
event OnAllClientsComplete(){}
simulated event Execute(){}
simulated event SetUnit(XGUnitNativeBase kUnit){}
simulated function ApplyCursorSettings(CursorSetting CS){}
simulated function int GetTimeCost(){}
function bool CanBePerformed(){}
simulated function OnTurnTimerExpired(){};
simulated event CompleteAction(){}
simulated function InternalCompleteAction(){};
simulated event DecRefActionForAllLocalPlayers(){}
function DecRefActionForPlayer(XComTacticalController kPlayerController){}
simulated function Abort(){};
simulated function bool BlocksInput(){}
simulated function bool IsModal(){}
static simulated function int BaseTimeCost(){}
simulated function bool GetPathingDestination(out Vector OutDestination){}
simulated event OnInInterruptibleState(){}
simulated event Destroyed(){}
simulated event bool IsDoneWithAbility(XGAbility kAbility){}
simulated event WaitForInitialReplication(){}
simulated function OnInitialReplicationComplete(){}
simulated function bool Projectile_OverrideStartPositionAndDir(out Vector tempTrace, out Vector tempDir){}
simulated function Projectile_OnInit(XComProjectile kProjectile){};
simulated function Projectile_OnShutdown(XComProjectile kProjectile){};
simulated function Projectile_OnDealDamage(XComProjectile kProjectile){};
simulated function bool HasMultipleTargets(out array<XGUnit> arrTarget_out){}
simulated function bool StopMove(XGAction.EStopMoveType kType){}
simulated function string GetDebugHangLog(){}
simulated function DebugLogHang(){}

simulated state WaitForFinalReplication{
    simulated event BeginState(name PrevStateName){}
    simulated event EndState(name NextStateName){}
    simulated event PushedState(){}
    simulated function OnFinalReplicationComplete(){}
    simulated event PoppedState(){}
}

simulated state Executing{
    simulated function BeginState(name previousState){}
    simulated function PushedState(){}
}

simulated state WaitingForInitialReplication{}
simulated state WaitingForFinalLocomotionData{}
simulated state NetForceDestroying{
    simulated event BeginState(name PrevStateName){}
    simulated event EndState(name NextStateName){}
    simulated event PushedState(){}
    simulated event PoppedState(){}
}

