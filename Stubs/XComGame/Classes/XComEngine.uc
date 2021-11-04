class XComEngine extends GameEngine
    transient
    native
    config(Engine);
//complete stub

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
var array<XComMCPEventListener> MCPEventListeners;

// Export UXComEngine::execGetMCP(FFrame&, void* const)
native static function XComMCP GetMCP();

// Export UXComEngine::execGetStringCRC(FFrame&, void* const)
native static function int GetStringCRC(string Text);

// Export UXComEngine::execGetMaxSaveSizeInBytes(FFrame&, void* const)
native static function int GetMaxSaveSizeInBytes();

// Export UXComEngine::execSetRandomSeeds(FFrame&, void* const)
native static final function SetRandomSeeds(int iSeed);

// Export UXComEngine::execGetSyncSeed(FFrame&, void* const)
native static final function int GetSyncSeed();

// Export UXComEngine::execSyncRand(FFrame&, void* const)
native static final function int SyncRand(int Max, string strFnName);

// Export UXComEngine::execSyncFRand(FFrame&, void* const)
native static final function float SyncFRand(string strFnName);

// Export UXComEngine::execSyncVRand(FFrame&, void* const)
native static final function Vector SyncVRand(string strFnName);

// Export UXComEngine::execGetARandomSeed(FFrame&, void* const)
native static final function int GetARandomSeed();

// Export UXComEngine::execGetLastInitSeed(FFrame&, void* const)
native static final function int GetLastInitSeed();

// Export UXComEngine::execPlaySpecificLoadingMovie(FFrame&, void* const)
native static final function PlaySpecificLoadingMovie(string MovieName);

// Export UXComEngine::execPlayLoadMapMovie(FFrame&, void* const)
native function bool PlayLoadMapMovie(optional int Idx=0);

// Export UXComEngine::execPlayMovie(FFrame&, void* const)
native static final function PlayMovie(bool bLoop, string MovieFilename, optional int StartFrame=0);

// Export UXComEngine::execWaitForMovie(FFrame&, void* const)
native static final function WaitForMovie();

// Export UXComEngine::execIsWaitingForMovie(FFrame&, void* const)
native static final function bool IsWaitingForMovie();

// Export UXComEngine::execIsMoviePlaying(FFrame&, void* const)
native static final function bool IsMoviePlaying(string MovieName);

// Export UXComEngine::execIsAnyMoviePlaying(FFrame&, void* const)
native static final function bool IsAnyMoviePlaying();

// Export UXComEngine::execIsLoadingMoviePlaying(FFrame&, void* const)
native static final function bool IsLoadingMoviePlaying();

// Export UXComEngine::execStopCurrentMovie(FFrame&, void* const)
native static final function StopCurrentMovie();

// Export UXComEngine::execPauseMovie(FFrame&, void* const)
native static final function PauseMovie();

// Export UXComEngine::execUnpauseMovie(FFrame&, void* const)
native static final function UnpauseMovie();
simulated function int ScriptDebugSyncRand(int Max){}
simulated function int ScriptDebugSyncFRand(){}
native final function SetCurrentDeviceID(int NewDeviceID, optional bool bProfileSignedOut);
event bool AreStorageWritesAllowed(optional bool bIgnoreDeviceStatus, optional int RequiredSize=10000000){}
native final function bool HasStorageDeviceBeenRemoved();
native static final function float GetCurrentTime();
native final function int GetCurrentDeviceID();
event bool IsCurrentDeviceValid(optional int SizeNeeded){}
function Object GetContentManager(){}
function Object GetProfileSettings(){}
function CreateProfileSettings(){}
native static function bool IsPointInTriangle(const out Vector vP, const out Vector vA, const out Vector vB, const out Vector vC);
function AddMCPEventListener(XComMCPEventListener Listener){}
function RemoveMCPEventListener(XComMCPEventListener Listener){}
event BuildLocalization(){}
native static final function AddStreamingTextureSlaveLocation(Vector Loc, Rotator Rot, float Duration, optional bool bOverrideAll=false);
native static final function Class FindClassType(string FindClassName);


defaultproperties
{
    OnlineEventMgrClassName="XComGame.XComOnlineEventMgr"
}