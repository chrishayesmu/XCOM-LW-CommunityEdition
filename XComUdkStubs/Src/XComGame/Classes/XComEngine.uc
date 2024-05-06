class XComEngine extends GameEngine
    transient
    native
    config(Engine);

const MAX_DATASIZE_FOR_ALL_SAVEGAMES = 10000000;

enum ESaveGameAction
{
    SaveGameAction_None,
    SaveGameAction_Load,
    SaveGameAction_Save,
    SaveGameAction_MAX
};

struct native CheckpointTime
{
    var int SecondsSinceMidnight;
    var int Day;
    var int Month;
    var int Year;
};

struct native SaveGameEvent
{
    var ESaveGameAction Action;
    var Checkpoint AssociatedCheckpoint;
};

var SaveGameEvent PendingCheckpointEvents;
var Checkpoint CurrentCheckpoint;
var int CurrentUserID;
var private int CurrentDeviceID;
var bool bShouldWriteCheckpointToDisk;
var const transient bool bHasSelectedValidStorageDevice;
var XComContentManager ContentManager;
var XComMapManager MapManager;
var XComMCP MCPManager;
var XComOnlineProfileSettings XComProfileSettings;
var XGLocalizeContext LocalizeContext;
var XGGameCoreTag GameCoreTag;
var XGWeaponTag WeaponTag;
var XGAbilityTag AbilityTag;
var XGSoldierTag SoldierTag;
var XGParamTag ParamTag;
var XGBulletTag BulletTag;
var int m_iSyncRandSeed;
var init string NextLoadMapMovie;
var int m_iSeedOverride;
var int m_iLastInitSeed;
var privatewrite array<XComMCPEventListener> MCPEventListeners;

defaultproperties
{
    OnlineEventMgrClassName="XComGame.XComOnlineEventMgr"
}