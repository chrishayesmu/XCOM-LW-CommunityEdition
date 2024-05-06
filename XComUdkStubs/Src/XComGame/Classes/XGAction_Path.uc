class XGAction_Path extends XGAction_Idle
    native(Action)
    notplaceable
    hidecategories(Navigation);

const MOUSE_RIBBON_DELAY_TIME = 0.5;
const TACTICAL_GRID_DELAY_TIME = 0.2;

struct native InitialReplicationData_XGAction_Path
{
    var int m_iMaxPathCost;

    structdefaultproperties
    {
        m_iMaxPathCost=-1
    }
};

var transient CursorSetting m_kCursorSettings;
var privatewrite Vector m_vLookAtCursorPos;
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
var privatewrite bool m_bPushStateLookAtCursorCameraTransition;
var privatewrite bool m_bClientProxyWasInStateLookAtCursorCameraTransition;
var private bool m_bInitialReplicationDataReceived_XGAction_Path;
var privatewrite repnotify bool m_bCompletedBeforeExecutingSchedule;
var XComActionIconManager IconManager;
var XComLevelBorderManager LevelBorderMgr;
var XComWorldData WorldData;
var int m_iBoundToClientMoveActionProxyID;
var XComUnitPawnNativeBase m_kClientProxyPathingPawnMyUnit;
var privatewrite repnotify InitialReplicationData_XGAction_Path m_kInitialReplicationData_XGAction_Path;

defaultproperties
{
    m_kCursorSettings=(Material=none,Color=(R=4.0,G=0.750,B=0.20,A=1.0))
    m_iLastTileX=-1
    m_iLastTileY=-1
    m_iLastTileZ=-1
    m_bExecutingScheduleBeginState_ModifyCursor=true
    m_bExecutingScheduleBeginState_ModifyPath=true
    m_bDestroyTrailOnDestroyed=true
    m_kInitialReplicationData_XGAction_Path=(m_iMaxPathCost=-1)
}