class XComMCP extends MCPBase
    native
    dependson(XComMCPTypes)
	dependson(XGGameData);
//complete stub

var array<GlobalRecapStat> GlobalRecapStats;
var array<MCPEventRequest> EventItems;
var const array<MCPEventRequest> ActiveRequests;
var bool bEnableMcpService;
var bool McpStatsDisableReporting;
var private transient bool Tracking;
var private native transient Array_Mirror KeyCountEntries;
var private native transient Array_Mirror MetricEntries;
var private transient string StringBlob;
var const localized string ServiceNotAvailable;
var OnlineSubsystem OnlineSub;
var array<XComMCPEventListener> EventListeners;
var EMCPInitStatus eInitStatus;
var delegate<OnRecapStatsRetrieved> __OnRecapStatsRetrieved__Delegate;
var delegate<OnEventCompleted> __OnEventCompleted__Delegate;

delegate OnRecapStatsRetrieved();
delegate OnEventCompleted(bool bWasSuccessful, EOnlineEventType EventType);


native function Init(bool bLoggedIntoOnlineProfile);
native function bool GetINIFromServer(string INIFilename);

// Export UXComMCP::execCheckWhiteList(FFrame&, void* const)
native function string CheckWhiteList(int iControllerID);

// Export UXComMCP::execAddKeyCount(FFrame&, void* const)
native static function AddKeyCount(string Key, int Value, int Type);

// Export UXComMCP::execGetPlayerUID(FFrame&, void* const)
private native static final function int GetPlayerUID(string PlayerName, string Ident);

// Export UXComMCP::execSetSPPlayerUID(FFrame&, void* const)
private native static final function SetSPPlayerUID(int Uid);

// Export UXComMCP::execGetSPPlayerUID(FFrame&, void* const)
private native static final function int GetSPPlayerUID();

// Export UXComMCP::execSnapshotMemory(FFrame&, void* const)
private native static final function SnapshotMemory();

// Export UXComMCP::execGameTrack(FFrame&, void* const)
private native static final function GameTrack();

// Export UXComMCP::execGameAddData(FFrame&, void* const)
private native static final function GameAddData(string XmlData);

// Export UXComMCP::execGameTrackEnd(FFrame&, void* const)
private native static final function GameTrackEnd();

// Export UXComMCP::execPostRecapStats(FFrame&, void* const)
private native static final function PostRecapStats(int GameID, XGRecapSaveData RecapSaveData, EDifficultyLevel Difficulty, bool Success, bool bIsCampaignEnd);

// Export UXComMCP::execPostMemoryStats(FFrame&, void* const)
private native static final function PostMemoryStats(string MissionName);

// Export UXComMCP::execGetPlatform(FFrame&, void* const)
native static function int GetPlatform();

// Export UXComMCP::execGetCurrentUTCTime(FFrame&, void* const)
native static function string GetCurrentUTCTime();

// Export UXComMCP::execGetMemoryUsage(FFrame&, void* const)
native static function float GetMemoryUsage();

// Export UXComMCP::execGetInitMem(FFrame&, void* const)
private native static final function float GetInitMem();

// Export UXComMCP::execGetPeakMem(FFrame&, void* const)
private native static final function float GetPeakMem();

// Export UXComMCP::execGetRecapStat(FFrame&, void* const)
private native static final function bool GetRecapStat(ERecapStats eStat, out string Buffer);

// Export UXComMCP::execGetRecapStatAvg(FFrame&, void* const)
private native static final function bool GetRecapStatAvg(ERecapStats eCountStat, ERecapStats eSumStat, out string Buffer);

// Export UXComMCP::execGetBaseURL(FFrame&, void* const)
native static function string GetBaseURL();

// Export UXComMCP::execRecapStatsRetrieved(FFrame&, void* const)
protected native function RecapStatsRetrieved();

// Export UXComMCP::execSetMetricValue(FFrame&, void* const)
native static function SetMetricValue(string Key, int Value);

// Export UXComMCP::execPostMetricValues(FFrame&, void* const)
native static function PostMetricValues();
static function StartMatchSP(string MapName, XGPlayer kPlayer, XGPlayer kAI);
native static function bool GetGlobalRecapStats(EDifficultyLevel Difficulty, bool Success, delegate<OnRecapStatsRetrieved> OnStatsReceived);
native static function ClearGetGlobalRecapStatsDelegate();
function AddEventListener(XComMCPEventListener Listener){}
function RemoveEventListener(XComMCPEventListener Listener){}
event NotifyNotifyMCPInitialized(){}
event NotifyGetINIFromServerCompleted(bool bSuccess, string INIFilename, string INIContents){}
static function EndMatchSP(){}
static function SubmitRecapStats(int GameID, XGRecapSaveData RecapSaveData, EDifficultyLevel Difficulty, bool Success, bool bIsCampaignEnd){}
static function string GetGlobalAvgStat(ERecapStats eCountStat, ERecapStats eSumStat){}
static function string GetGlobalStat(ERecapStats eStat){}
static function int STAT_GetProfileStat(EProfileStats eStat){}
static event int GetProfileStat(EProfileStats eStat){}
protected native function EventCompleted(bool bWasSuccessful, XComMCPTypes.EOnlineEventType EventType);
native function bool PingMCP(delegate<OnEventCompleted> dOnPingCompleted);
native function UploadPlayerInfo(byte LocalUserNum);
function OnReadProfileSettingsCompleteDelegate(byte LocalUserNum, EStorageResult eResult){}
function OnWriteProfileSettingsCompleteDelegate(byte LocalUserNum, bool bWasSuccessful){}
function OnReadPlayerStorageCompleteDelegate(byte LocalUserNum, EStorageResult eResult){}
function OnWritePlayerStorageCompleteDelegate(byte LocalUserNum, bool bWasSuccessful){}
event FinishInit(){}
