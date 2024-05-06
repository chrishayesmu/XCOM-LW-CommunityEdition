class XComOnlineEventMgr extends OnlineEventMgr
    native;

const CheckpointVersion = 16;
const StorageRemovalWarningDelayTime = 1.0;

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

    structdefaultproperties
    {
        m_kUniqueID=(Uid=none)
        m_bMatchStarted=false
        m_iWins=-1
        m_iLosses=-1
        m_iDisconnects=-1
        m_iSkillRating=-1
        m_iRank=-1
    }
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

    structdefaultproperties
    {
        m_bIsRanked=false
        m_bAutomatch=false
        m_iMapIndex=0
        m_strMapName=""
        m_eNetworkType=EMPNetworkType.eMPNetworkType_Public
        m_eGameType=EMPGameType.eMPGameType_Deathmatch
        m_iTurnTimeSeconds=0
        m_iMaxSquadCost=0
        m_kLocalPlayerInfo=(m_kUniqueID=(Uid=none),m_bMatchStarted=false,m_iWins=-1,m_iLosses=-1,m_iDisconnects=-1,m_iSkillRating=-1,m_iRank=-1)
        m_kRemotePlayerInfo=(m_kUniqueID=(Uid=none),m_bMatchStarted=false,m_iWins=-1,m_iLosses=-1,m_iDisconnects=-1,m_iSkillRating=-1,m_iRank=-1)
    }
};

var TMPLastMatchInfo m_kMPLastMatchInfo;
var XComEngine LocalEngine;
var XComMCP MCP;
var XComCopyProtection CopyProtection;
var XComOnlineStatsReadDeathmatchRanked m_kStatsRead;
var XComPlayerController m_kStatsReadPlayerController;
var privatewrite bool m_bStatsReadInProgress;
var privatewrite bool m_bStatsReadSuccessful;
var privatewrite bool bHasStorageDevice;
var privatewrite bool bStorageSelectPending;
var privatewrite bool bLoginUIPending;
var privatewrite bool bSaveDeviceWarningPending;
var privatewrite bool bInShellLoginSequence;
var privatewrite bool bExternalUIOpen;
var privatewrite bool bUpdateSaveListInProgress;
var bool bWarnedOfOnlineStatus;
var bool bAcceptedInviteDuringGameplay;
var privatewrite bool bRequireLogin;
var privatewrite bool bAllowInactiveProfiles;
var privatewrite bool bOnlineSubIsSteamworks;
var privatewrite bool bOnlineSubIsPSN;
var privatewrite bool bOnlineSubIsLive;
var privatewrite bool bHasLogin;
var privatewrite bool bHasProfileSettings;
var privatewrite bool bShowingLoginUI;
var privatewrite bool bShowingLossOfDataWarning;
var privatewrite bool bShowingLoginRequiredWarning;
var privatewrite bool bShowingLossOfSaveDeviceWarning;
var privatewrite bool bShowSaveIndicatorForProfileSaves;
var privatewrite bool bCancelingShellLoginDialog;
var privatewrite bool bMCPEnabledByConfig;
var privatewrite bool bSaveDataOwnerErrHasShown;
var privatewrite bool bSaveDataOwnerErrPending;
var privatewrite bool bDelayDisconnects;
var privatewrite bool bDisconnectPending;
var privatewrite bool bConfigIsUpToDate;
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
var privatewrite int StorageDeviceIndex;
var privatewrite string StorageDeviceName;
var privatewrite float fSaveDeviceWarningPendingTimer;
var privatewrite ELoginStatus LoginStatus;
var privatewrite EOnlineStatusType OnlineStatus;
var privatewrite ELoginStatus m_eNewLoginStatusForDestroyOnlineGame_OnLoginStatusChange;
var private int m_iCurrentGame;
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
var privatewrite UniqueNetId m_kNewIdForDestroyOnlineGame_OnLoginStatusChange;
var private array< delegate<ShellLoginComplete> > m_BeginShellLoginDelegates;
var private array< delegate<SaveProfileSettingsComplete> > m_SaveProfileSettingsCompleteDelegates;
var private array< delegate<UpdateSaveListStarted> > m_UpdateSaveListStartedDelegates;
var private array< delegate<UpdateSaveListComplete> > m_UpdateSaveListCompleteDelegates;
var private array< delegate<OnlinePlayerInterface.OnLoginStatusChange> > m_LoginStatusChangeDelegates;
var private array< delegate<OnConnectionProblem> > m_ConnectionProblemDelegates;
var private array< delegate<OnSaveDeviceLost> > m_SaveDeviceLostDelegates;

delegate SaveProfileSettingsComplete(bool bWasSuccessful)
{
}

delegate UpdateSaveListStarted()
{
}

delegate UpdateSaveListComplete(bool bWasSuccessful)
{
}

delegate ReadSaveGameComplete(bool bWasSuccessful)
{
}

delegate WriteSaveGameComplete(bool bWasSuccessful)
{
}

delegate ShellLoginComplete(bool bWasSuccessful)
{
}

delegate OnConnectionProblem()
{
}

delegate OnSaveDeviceLost()
{
}

defaultproperties
{
    bAchivementsEnabled=true
    StorageDeviceIndex=-1
    ShowSaveIndicatorLeadTime=0.30
}