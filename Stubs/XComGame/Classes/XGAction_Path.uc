class XGAction_Path extends XGAction_Idle
    native(Action);
//complete stub

const MOUSE_RIBBON_DELAY_TIME = 0.5;
const TACTICAL_GRID_DELAY_TIME = 0.2;

struct native InitialReplicationData_XGAction_Path
{
    var int m_iMaxPathCost;
};

var transient CursorSetting m_kCursorSettings;
var Vector m_vLookAtCursorPos;
var private int m_iLastTileX;
var private int m_iLastTileY;
var private int m_iLastTileZ;
var private float m_fTimeInTile;
var float fTime;
var bool m_bExecutingScheduleBeginState_ModifyCursor;
var bool m_bExecutingScheduleBeginState_ModifyPath;
var bool m_bNoCloseCombat;
var bool m_bDoPathingTick;
var bool m_bDestroyTrailOnDestroyed;
var bool m_bPushStateLookAtCursorCameraTransition;
var bool m_bClientProxyWasInStateLookAtCursorCameraTransition;
var private bool m_bInitialReplicationDataReceived_XGAction_Path;
var repnotify bool m_bCompletedBeforeExecutingSchedule;
var XComActionIconManager IconManager;
var XComLevelBorderManager LevelBorderMgr;
var XComWorldData WorldData;
var int m_iBoundToClientMoveActionProxyID;
var XComUnitPawnNativeBase m_kClientProxyPathingPawnMyUnit;
var repnotify InitialReplicationData_XGAction_Path m_kInitialReplicationData_XGAction_Path;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_bCompletedBeforeExecutingSchedule, m_kInitialReplicationData_XGAction_Path;
}

simulated event ReplicatedEvent(name VarName){}
function bool Init(XGUnit kUnit){}
simulated event SimulatedInit(){}
simulated event InitFromClientProxyAction(XGAction kClientProxyAction){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function bool InternalIsInterruptibleBy(class<XGAction> kActionClass){}
simulated function NotifyPresentationLayersInitialized(){}
simulated function InternalCompleteAction(){}
simulated function InitIconManager(){}
simulated function bool IsEmpty(){}
simulated function ClearPath(){}
simulated function XComPathingPawn GetPathPawn(){}
simulated function bool IsLocationCloseCombat(Vector Loc, optional bool bRelaxedRange){}
simulated function bool ComputePathWithGetClosestActionLocation(){}
simulated function bool CanDash(){}
simulated function Dash(){}
reliable server function ServerDash(){}
simulated function bool Perform_ComputePath(Vector vLoc, optional bool bForceTileCacheUpdate){}
simulated function bool ComputePathNormal(){}
simulated function UpdateShowPathingPawnRibbon(float fDeltaTime){}
simulated function UpdateShowFullTacticalGrid(){}
final simulated function bool ShouldTransitionCameraToCursorLocation(Vector vCursorLocation){}
simulated event Destroyed(){}
simulated event DoPathingTick(float DeltaTime){}

simulated state Executing{

    simulated function InternalCompleteAction(){}
}

simulated state ExecutingSchedule
{
    simulated function bool InternalIsInterruptibleBy(class<XGAction> kActionClass){}
    simulated event BeginState(name nmPrevState){}
    simulated event EndState(name nmNextState){}
}

simulated state LookAtCursorCameraTransition
{
    simulated function InternalCompleteAction(){}
}

