class XComOnlineEventMgr extends OnlineEventMgr
    native;
//complete stub
enum EAchievementType
{
    AT_IronMan,
    AT_MeetNewPeople,
    AT_Xavier,
    AT_HumanitySavior,
    AT_EarthFirst,
    AT_OurFinestHour,
    AT_Neo,
    AT_BadaBoom,
    AT_WelcomeToEarth,
    AT_AndHeRode,
    AT_ShootingStars,
    AT_AintNoCavalry,
    AT_AsAScalpel,
    AT_Edison,
    AT_THePersuader,
    AT_AllEmployees,
    AT_BeyondTheVeil,
    AT_PrisonerOfWar,
    AT_TheWatchers,
    AT_XMarksTheSpot,
    AT_SeeAllKnowAll,
    AT_OnTheShoulders,
    AT_RideTheLightning,
    AT_EyeInTheSky,
    AT_AllTogehterNow,
    AT_HunterKiller,
    AT_ManNoMore,
    AT_Bubonic,
    AT_WeHappyFew,
    AT_TheHardestRoad,
    AT_WorthEveryPenny,
    AT_Oppenheimer,
    AT_OneGunAtATime,
    AT_Skunkworks,
    AT_IsEveryoneOk,
    AT_Theory,
    AT_AndPractice,
    AT_WetWork,
    AT_ContinentalFellow,
    AT_WhatWondersAwait,
    AT_UpAndRunning,
    AT_CombatReady,
    AT_DrumsInTheDeep,
    AT_HappyToOblige,
    AT_AndHellsComming,
    AT_OffMyPlanet,
    AT_TablesTurned,
    AT_AndSoItBegins,
    AT_MightBeALittleOff,
    AT_TheRunaWays,
    AT_NewFriend,
    AT_BaitTheHook,
    AT_BiggerTheyAre,
    AT_RisingDragon,
    AT_AllAboard,
    AT_WhoNeedsLimbs,
    AT_ALittleBitAlien,
    AT_EnemyWithin,
    AT_SteelMartyr,
    AT_ApotheosisDenied,
    AT_TheyShallNotPass,
    AT_ZomBGone,
    AT_FourAces,
    AT_TheMeldSquad,
    AT_Shieldbuster,
    AT_SomeoneYourOwnSize,
    AT_TakingALoadOff,
    AT_WhereInTheWorld,
    AT_MindTheStep,
    AT_NiceCover,
    AT_ByOurPowersCombined,
    AT_RiseOfTheMachines,
    AT_MutatisMutandis,
    AT_MentalMinefield,
    AT_AngerManagement,
    AT_RemingtonMaxRemington,
    AT_Gday,
    AT_RegenerateThis,
    AT_TinglingSensation,
    AT_PainInTheNeck,
    AT_SolidProspect,
    AT_HellHathNoFuries,
    AT_EliteDefense,
    AT_GuardianOfEarth,
    AT_AllHandsOnDeck,
    AT_MAX
};


enum EOnlineStatusType
{
    OnlineStatus_MainMenu,
    OnlineStatus_InGameSP,
    OnlineStatus_InRankedMP,
    OnlineStatus_InUnrankedMP,
    OnlineStatus_MAX
};

enum EQuitReason
{
    QuitReason_None,
    QuitReason_UserQuit,
    QuitReason_SignOut,
    QuitReason_LostDlcDevice,
    QuitReason_InactiveUser,
    QuitReason_LostConnection,
    QuitReason_LostLinkConnection,
    QuitReason_OpponentDisconnected,
    QuitReason_MAX
};

struct native TMPLastMatchInfo_Player
{
    var UniqueNetId m_kUniqueID;
    var bool m_bMatchStarted;
    var int m_iWins;
    var int m_iLosses;
    var int m_iDisconnects;
    var int m_iSkillRating;
    var int m_iRank;
};

struct native TMPLastMatchInfo
{
    var bool m_bIsRanked;
    var bool m_bAutomatch;
    var int m_iMapIndex;
    var string m_strMapName;
    var XComMPData.EMPNetworkType m_eNetworkType;
    var XComMPData.EMPGameType m_eGameType;
    var int m_iTurnTimeSeconds;
    var int m_iMaxSquadCost;
    var TMPLastMatchInfo_Player m_kLocalPlayerInfo;
    var TMPLastMatchInfo_Player m_kRemotePlayerInfo;
};

var TMPLastMatchInfo m_kMPLastMatchInfo;
var XComEngine LocalEngine;
//var XComMCP MCP;
//var XComCopyProtection CopyProtection;
//var XComOnlineStatsReadDeathmatchRanked m_kStatsRead;
var XComPlayerController m_kStatsReadPlayerController;
var bool m_bStatsReadInProgress;
var bool m_bStatsReadSuccessful;
var bool bHasStorageDevice;
var bool bStorageSelectPending;
var bool bLoginUIPending;
var bool bSaveDeviceWarningPending;
var bool bInShellLoginSequence;
var bool bExternalUIOpen;
var bool bUpdateSaveListInProgress;
var bool bWarnedOfOnlineStatus;
var bool bAcceptedInviteDuringGameplay;
var bool bRequireLogin;
var bool bAllowInactiveProfiles;
var bool bOnlineSubIsSteamworks;
var bool bOnlineSubIsPSN;
var bool bOnlineSubIsLive;
var bool bHasLogin;
var bool bHasProfileSettings;
var bool bShowingLoginUI;
var bool bShowingLossOfDataWarning;
var bool bShowingLoginRequiredWarning;
var bool bShowingLossOfSaveDeviceWarning;
var bool bShowSaveIndicatorForProfileSaves;
var bool bCancelingShellLoginDialog;
var bool bMCPEnabledByConfig;
var bool bSaveDataOwnerErrHasShown;
var bool bSaveDataOwnerErrPending;
var bool bDelayDisconnects;
var bool bDisconnectPending;
var bool bConfigIsUpToDate;
var bool bSaveExplanationScreenHasShown;
var bool bPerformingStandardLoad;
var bool bPerformingTransferLoad;
var bool bIsProfileWriteWaiting;
var bool bCachedForceSaveIndicatorValue;
var bool bShowingSaveIndicator;
var bool CheckpointIsSerializing;
var bool CheckpointIsWritingToDisk;
var bool ProfileIsSerializing;
var bool bHasBubonic;
var private bool bAchivementsEnabled;
var bool bAchievementsDisabledXComHero;
var private bool bShuttleToMPMainMenu;
var private bool bShuttleToStartScreen;
var bool bHasWonAny;
var bool bHasWonEasy;
var bool bHasWonHard;
var bool bHasWonClassic;
var int StorageDeviceIndex;
var string StorageDeviceName;
var float fSaveDeviceWarningPendingTimer;
var ELoginStatus LoginStatus;
var EOnlineStatusType OnlineStatus;
var ELoginStatus m_eNewLoginStatusForDestroyOnlineGame_OnLoginStatusChange;
var int m_iCurrentGame;
var int LoadGameContentCacheIndex;
var init array<init byte> TransportSaveData;
var init array<init byte> StrategySaveData;
var int StrategySaveDataCheckpointVersion;
var init array<init byte> SaveLoadBuffer;
var float StorageWriteCooldownTimer;
var float ShownSaveIndicatorTime;
var float ShowSaveIndicatorDuration;
var float ShowSaveIndicatorLeadTime;
var Checkpoint CurrentTacticalCheckpoint;
var Checkpoint StrategyCheckpoint;
var Checkpoint TacticalCheckpoint;
var Checkpoint TransportCheckpoint;
var private int DLCWatchVarHandle;
var const localized string m_strIronmanLabel;
var const localized string m_strAutosaveLabel;
var const localized string m_strQuicksaveLabel;
var const localized string m_strGameLabel;
var const localized string m_strSaving;
var const localized string m_sLoadingProfile;
var const localized string m_sLossOfDataTitle;
var const localized string m_sLossOfDataWarning;
var const localized string m_sLossOfDataWarning360;
var const localized string m_sNoStorageDeviceSelectedWarning;
var const localized string m_sLoginWarning;
var const localized string m_sLoginWarningPC;
var const localized string m_sLossOfSaveDeviceWarning;
var const localized string m_strReturnToStartScreenLabel;
var const localized string m_sInactiveProfileMessage;
var const localized string m_sLoginRequiredMessage;
var const localized string m_sCorrupt;
var const localized string m_sSaveDataOwnerErrPS3;
var const localized string m_sSaveDataHeroErrPS3;
var const localized string m_sSaveDataHeroErr360PC;
var const localized string m_sSlingshotDLCFriendlyName;
var const localized string m_sEliteSoldierPackDLCFriendlyName;
var const localized string m_aRichPresenceStrings[EOnlineStatusType];
var UniqueNetId m_kNewIdForDestroyOnlineGame_OnLoginStatusChange;
var private array< delegate<ShellLoginComplete> > m_BeginShellLoginDelegates;
var private array< delegate<SaveProfileSettingsComplete> > m_SaveProfileSettingsCompleteDelegates;
var private array< delegate<UpdateSaveListStarted> > m_UpdateSaveListStartedDelegates;
var private array< delegate<UpdateSaveListComplete> > m_UpdateSaveListCompleteDelegates;
//var private array< delegate<OnLoginStatusChange> > m_LoginStatusChangeDelegates;
var private array< delegate<OnConnectionProblem> > m_ConnectionProblemDelegates;
var private array< delegate<OnSaveDeviceLost> > m_SaveDeviceLostDelegates;
var delegate<SaveProfileSettingsComplete>  __SaveProfileSettingsComplete__Delegate;
var delegate<UpdateSaveListStarted> __UpdateSaveListStarted__Delegate;
var delegate<UpdateSaveListComplete> __UpdateSaveListComplete__Delegate;
var delegate<ReadSaveGameComplete> __ReadSaveGameComplete__Delegate;
var delegate<WriteSaveGameComplete> __WriteSaveGameComplete__Delegate;
var delegate<ShellLoginComplete> __ShellLoginComplete__Delegate;
var delegate<OnConnectionProblem> __OnConnectionProblem__Delegate;
var delegate<OnSaveDeviceLost> __OnSaveDeviceLost__Delegate;

delegate SaveProfileSettingsComplete(bool bWasSuccessful);
delegate UpdateSaveListStarted();
delegate UpdateSaveListComplete(bool bWasSuccessful);
delegate ReadSaveGameComplete(bool bWasSuccessful);
delegate WriteSaveGameComplete(bool bWasSuccessful);
delegate ShellLoginComplete(bool bWasSuccessful);
delegate OnConnectionProblem();
delegate OnSaveDeviceLost();

event Init(){}
private final simulated function LoginChangeDelegate(byte LocalUserNum){}
function bool SaveInProgress(){}
private final function LoginCancelledDelegate(){}
private final simulated function LoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId){}
private final simulated function OnDestroyOnlineGameComplete_LoginStatusChange(name SessionName, bool bWasSuccessful){}
simulated function RefreshLoginStatus(){}
private final function LogoutCompletedDelegate(bool bWasSuccessful){}
private final function DeviceSelectionDoneDelegate(bool bWasSuccessful){}
private final simulated function StorageDeviceChangeDelegate(){}
private final simulated function ExternalUIChangedDelegate(bool bOpen){}
private final function ReadAchievementsCompleteDelegate(int TitleId){}
private final function ReadProfileSettingsCompleteDelegate(byte LocalUserNum, OnlineSubsystem.EStorageResult eResult){}
private final function ConfirmCorruptProfileDestructionCallback(UIDialogueBox.EUIAction Action){}
private final function ReadPlayerStorageCompleteDelegate(byte LocalUserNum, OnlineSubsystem.EStorageResult eResult){}
private final function WriteProfileSettingsCompleteDelegate(byte LocalUserNum, bool bWasSuccessful){}
private final function WritePlayerStorageCompleteDelegate(byte LocalUserNum, bool bWasSuccessful){}
private final function OnUpdateSaveListComplete(bool bWasSuccessful){}
private native final function RefreshSaveIDs();
private native final function CheckSaveIDs(out array<OnlineSaveGame> SaveGames);
private native final function OnReadSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName);
private final function OnWriteSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName){}
function UpdateCurrentGame(int iGame){}
function int GetCurrentGame(){}
event ShowPostLoadMessages(){}
private final function SetupDefaultProfileSettings(){}
function AddBeginShellLoginDelegate(delegate<ShellLoginComplete> ShellLoginCompleteCallback){}
function ClearBeginShellLoginDelegate(delegate<ShellLoginComplete> ShellLoginCompleteCallback){}
function BeginShellLogin(int ControllerId){}
protected function SetActiveController(int ControllerId){}
private final function ClearScreenUI(){}
private final function InitializeDelegates(){}
private final function ShellLoginProgressMsg(string sProgressMsg){}
private final function ShellLoginHideProgressDialog(){}
private final function ShellLoginUserLoginComplete(){}
private final function RequestLogin(){}
private final function RequestLoginDialogCallback(UIDialogueBox.EUIAction Action){}
private final function ShellLoginHandleInactiveProfiles(){}
private final function InactiveProfilesDialogCallback(UIDialogueBox.EUIAction Action){}
private final function AbortShellLogin(){}
private final function EndShellLogin(){}
private final function ShellLoginDLCRefreshComplete(){}
private final function DownloadConfigFiles(){}
simulated function OnReadTitleFileComplete(bool bWasSuccessful, string Filename){}
native simulated function bool HasEliteSoldierPack();
native simulated function bool HasSlingshotPack();
native simulated function bool HasDLCEntitlement(int ContentId);
simulated function ReadProfileSettings(){}
simulated function QueueQuitReasonMessage(EQuitReason Reason, optional bool bIgnoreMsgAdd){}
simulated function ESystemMessageType GetSystemMessageForQuitReason(EQuitReason Reason){}
simulated function ReturnToStartScreen(EQuitReason Reason){}
simulated function InviteFailed(ESystemMessageType eSystemMessage, optional bool bTravelToMPMenus){}
simulated function DelayDisconnects(bool bDelay){}
function ReturnToMPMainMenuBase(){}
function bool IsAtMPMainMenu(){}
function ReturnToMPMainMenu(optional EQuitReason Reason){}
function bool GetShuttleToMPMainMenu(){}
function SetShuttleToMPMainMenu(bool ShouldShuttle){}
function SetShuttleToStartMenu(bool ShouldShuttle){}
private final function ClearLoginSettings(){}
simulated function ResetLogin(){}
function InitMCP(){}
function bool ShellLoginShowLoginUI(optional bool bCallLoginComplete){}
private final function OnShellLoginShowLoginUIComplete(bool bWasSuccessful){}
simulated function SelectStorageDevice(){}
function DeferredSaveProfileSettings(){}
function SaveProfileSettings(optional bool bForceShowSaveIndicator, optional bool bFromDeferred){}
function DebugSaveProfileSettingsCompleteDelegate(){}
function AddSaveProfileSettingsCompleteDelegate(delegate<SaveProfileSettingsComplete> dSaveProfileSettingsCompleteDelegate){}
function ClearSaveProfileSettingsCompleteDelegate(delegate<SaveProfileSettingsComplete> dSaveProfileSettingsCompleteDelegate){}
function CreateNewProfile(){}
private final function NewProfileSaveComplete(bool bWasSuccessful){}
private final simulated function LossOfDataWarning(string sWarningText){}
private final simulated function LossOfDataAccepted(UIDialogueBox.EUIAction eAction){}
private final simulated function NoStorageDeviceCallback(UIDialogueBox.EUIAction eAction){}
private final function CancelActiveShellLoginDialog(){}
private final simulated function LossOfSaveDevice(){}
private final simulated function LossOfSaveDeviceAccepted(UIDialogueBox.EUIAction eAction){}
private final function bool CanUnpauseLossOfSaveDeviceWarning(){}
event Tick(float DeltaTime){}
private final function bool IsPresentationLayerReady(){}
function bool WaitingForPlayerProfileRead(){}
function bool AreAchievementsEnabled(){}
function EnableAchievements(bool Enable, optional bool bXComHero){}
function UnlockAchievement(EAchievementType Type){}
native function DevOnlineMsg(string msg);
reliable client simulated function SetOnlineStatus(EOnlineStatusType NewOnlineStatus){}
reliable client simulated function RefreshOnlineStatus(){}
reliable client simulated function InitRichPresence(){}
private final function RequestLoginFeatures(){}
function bool ShowGamerCardUI(UniqueNetId PlayerID){}
function bool GetSaveGames(out array<OnlineSaveGame> SaveGames){}
function OnlineStatsRead GetOnlineStatsRead(){}
function bool GetOnlineStatsReadSuccess(){}
function bool IsReadyForMultiplayer(){}
function bool CheckForInactiveProfiles(){}
function bool CheckOnlineConnectivity(){}
function PerformNewScreenInit(){}
native function bool HasValidLoginAndStorage();
native function bool ReadProfileSettingsFromBuffer();
native function bool WriteProfileSettingsToBuffer();
function UpdateSaveGameList(){}
native function bool GetSaveSlotDescription(int SaveSlotIndex, out string Description);
native function bool GetSaveSlotMapName(int SaveSlotIndex, out string MapName);
native function bool GetSaveSlotLanguage(int SaveSlotIndex, out string Language);
private final event ReadSaveGameData(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName){}
private final event PreloadSaveGameData(byte LocalUserNum, bool Success, int GameNum, int SaveID){}
private final event WriteSaveGameData(byte LocalUserNum, int DeviceID, string Filename, bool IsAutosave, bool IsQuicksave, int SaveID, const out array<byte> SaveGameData, int SaveDataCRC){}
function ShowSaveIndicator(optional bool bProfileSave){}
function HideSaveIndicator(){}
event FillInHeaderForSave(out SaveGameHeader Header, out string SaveFriendlyName){}
native static function FormatTimeStamp(out string TimeStamp, int Year, int Month, int Day, int Hour, int Minute);
native function SortSavedGameListByTimestamp(out array<OnlineSaveGame> SaveGameList);
function bool ArePRIStatsNewerThanCachedVersion(XComPlayerReplicationInfo PRI){}
static function FillPRIFromLastMatchPlayerInfo(out TMPLastMatchInfo_Player kLastMatchPlayerInfo, XComPlayerReplicationInfo kPRI){}
static function FillLastMatchPlayerInfoFromPRI(out TMPLastMatchInfo_Player kLastMatchPlayerInfo, XComPlayerReplicationInfo kPRI){}
static function string TMPLastMatchInfo_ToString(const out TMPLastMatchInfo kLastMatchInfo){}
static function string TMPLastMatchInfo_Player_ToString(const out TMPLastMatchInfo_Player kLastMatchInfoPlayer){}
event OnDeleteSaveGameDataComplete(byte LocalUserNum){}
private final event DeleteSaveGameData(byte LocalUserNum, int DeviceID, string Filename){}
native function SaveGame(int SlotIndex, bool IsAutosave, bool IsQuicksave, optional delegate<WriteSaveGameComplete> WriteSaveGameCompleteCallback);
native function OnSaveCompleteInternal();
native function LoadGame(int SlotIndex, optional delegate<ReadSaveGameComplete> ReadSaveGameCompleteCallback);
native function FinishLoadGame();
native function DeleteSaveGame(int SlotIndex);
native function StartLoadFromStoredStrategy();

// Export UXComOnlineEventMgr::execFinishLoadFromStoredStrategy(FFrame&, void* const)
native function FinishLoadFromStoredStrategy();

// Export UXComOnlineEventMgr::execSaveToStoredStrategy(FFrame&, void* const)
native function SaveToStoredStrategy();

// Export UXComOnlineEventMgr::execSaveTransport(FFrame&, void* const)
native function SaveTransport();

// Export UXComOnlineEventMgr::execLoadTransport(FFrame&, void* const)
native function LoadTransport();

// Export UXComOnlineEventMgr::execReleaseCurrentTacticalCheckpoint(FFrame&, void* const)
native function ReleaseCurrentTacticalCheckpoint();

// Export UXComOnlineEventMgr::execGetNextSaveID(FFrame&, void* const)
native function int GetNextSaveID();

// Export UXComOnlineEventMgr::execSaveNameToID(FFrame&, void* const)
native function int SaveNameToID(string SaveFileName);

// Export UXComOnlineEventMgr::execSaveIDToFileName(FFrame&, void* const)
native function SaveIDToFileName(int SaveID, out string SaveFileName);

// Export UXComOnlineEventMgr::execCheckSaveDLCRequirements(FFrame&, void* const)
native function bool CheckSaveDLCRequirements(int SaveID, out string MissingDLC);

// Export UXComOnlineEventMgr::execGetNewSaveFileName(FFrame&, void* const)
private native final function GetNewSaveFileName(out string SaveFileName);

// Export UXComOnlineEventMgr::execDeleteSaveDataFromListPS3(FFrame&, void* const)
native function DeleteSaveDataFromListPS3();

// Export UXComOnlineEventMgr::execLoadedSaveDataFromAnotherUserPS3(FFrame&, void* const)
native function bool LoadedSaveDataFromAnotherUserPS3();

// Export UXComOnlineEventMgr::execStandardControllerInUsePS3(FFrame&, void* const)
native function bool StandardControllerInUsePS3(int ControllerIndex);

// Export UXComOnlineEventMgr::execGetSaveDeviceSpaceKB_Xbox360(FFrame&, void* const)
native function int GetSaveDeviceSpaceKB_Xbox360();

// Export UXComOnlineEventMgr::execCheckFreeSpaceForSave_Xbox360(FFrame&, void* const)
native function bool CheckFreeSpaceForSave_Xbox360();

// Export UXComOnlineEventMgr::execGamepadConnected_PC(FFrame&, void* const)
native static function bool GamepadConnected_PC();

// Export UXComOnlineEventMgr::execEnumGamepads_PC(FFrame&, void* const)
native static function EnumGamepads_PC();

function AddUpdateSaveListStartedDelegate(delegate<UpdateSaveListStarted> Callback){}
function ClearUpdateSaveListStartedDelegate(delegate<UpdateSaveListStarted> Callback){}
private final function CallUpdateSaveListStartedDelegates(){}
function AddUpdateSaveListCompleteDelegate(delegate<UpdateSaveListComplete> Callback){}
function ClearUpdateSaveListCompleteDelegate(delegate<UpdateSaveListComplete> Callback){}
private final function CallUpdateSaveListCompleteDelegates(bool bWasSuccessful){}
//function AddLoginStatusChangeDelegate(delegate<OnLoginStatusChange> Callback){}
//function ClearLoginStatusChangeDelegate(delegate<OnLoginStatusChange> Callback){}
private final function CallLoginStatusChangeDelegates(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId){}
function AddSaveDeviceLostDelegate(delegate<OnSaveDeviceLost> Callback){}
function ClearSaveDeviceLostDelegate(delegate<OnSaveDeviceLost> Callback){}
private final function CallSaveDeviceLostDelegates(){}
function AddNotifyConnectionProblemDelegate(delegate<OnConnectionProblem> Callback){}
function ClearNotifyConnectionProblemDelegate(delegate<OnConnectionProblem> Callback){}
function NotifyConnectionProblem(){}
function SwitchUsersThenTriggerAcceptedInvite(){}
function OnShellLoginComplete_SwitchUsers(bool bWasSuccessful){}
function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful){}
function bool IsPlayerInLobby(){}
function DisplaySystemMessage(string sSystemMessage, string sSystemTitle, optional delegate<DisplaySystemMessageComplete> dOnDisplaySystemMessageComplete=OnDisplaySystemMessageComplete){}
simulated function OnSystemMessageDialogueClosed(UIDialogueBox.EUIAction eAction, UICallbackData xUserData){}
native simulated function EnsureSavesAreComplete();

event OnSaveAsyncTaskComplete(){}
event OnMPLoadTimeout(){}
function bool OnSystemMessage_AutomatchGameFull(){}
function bool LastGameWasAutomatch(){}
function ResetAchievementState(){}
function string GetSystemMessageString(ESystemMessageType eMessageType){}
function string GetSystemMessageTitle(ESystemMessageType eMessageType){}
