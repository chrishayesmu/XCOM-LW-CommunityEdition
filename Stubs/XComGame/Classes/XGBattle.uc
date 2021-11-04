class XGBattle extends Actor
    abstract
    native(Core)
    notplaceable
    hidecategories(Navigation)
	DependsOn(XGGameData);
//complete stub

enum EBattleResult
{
    eResult_UNINITIALIZED,
    eResult_Victory,
    eResult_Defeat,
    eResult_Abandon,
    eResult_TimeOut,
    eResult_MAX
};

struct CheckpointRecord
{
    var XGBattleDesc m_kDesc;
    var XGLevel m_kLevel;
    var XGPlayer m_arrPlayers[4];
    var int m_iTurn;
    var int m_iNumPlayers;
    var int m_iPlayerTurn;
    var XGBattleResult m_kResults;
    var bool m_bTacticalIntroDone;
    var StrategyGameTransport m_kTransferSave;
    var XComAlienPodManager m_kPodMgr;
};

var XGBattleDesc m_kDesc;
var XGLevel m_kLevel;
var XGPlayer m_arrPlayers[4];
var repnotify int m_iTurn;
var int m_iNumPlayers;
var int m_iNumHumanPlayers;
var repnotify int m_iPlayerTurn;
var XGBattleResult m_kResults;
var TPawnContent Content;
var StrategyGameTransport m_kTransferSave;
var XComOnlineProfileSettings m_kProfileSettings;
var string m_strObjective;
var int m_iResult;
var bool m_iResultCachedThisFrame;
var bool m_bIsInited;
var bool m_bLoadingSave;
var bool m_bSkipVisUpdate;
var bool m_bLevelStreamingComplete;
var bool m_bShowLoadingScreen;
var repnotify bool m_bClientStart;
var bool m_bClientAlreadyStarted;
var bool m_bCloseCombatFromPodMovement;
var bool m_bTacticalIntroDone;
var bool m_bHQAssaultIntroDone;
var bool m_bFoundTacticalIntro;
var bool m_bPlayerTransition;
var bool m_bPlayCinematicIntro;
var bool m_bLoadKismetDataFromSave;
var const bool m_bAllowItemFragments;
var bool m_bSkipOuttroUI;
var bool m_bInPauseMenu;
var transient bool m_bAtBottomOfRunningStateBeginBlock;
var transient bool m_bServerAtBottomOfRunningStateBeginBlock;
var XGPlayer m_kActivePlayer;
var XGLoadoutMgr m_kLoadoutMgr;
var int m_iClientLastReplicatedPlayerTurn;
var class<XGBattleResult> m_kBattleResultClass;
var XGPlayer m_kCloseCombatInstigator;
var array<Sequence> CachedStreamingSequences;
var XComGrenadeManager m_kGrenadeMgr;
var XComZombieManager m_kZombieMgr;
var XGVolumeMgr m_kVolumeMgr;
var XComGlamManager m_kGlamMgr;
var SpawnAlienQueue m_kSpawnAlienQueue;
var Material m_kAOEDamageMaterial;
var Material m_kAOEDamageMaterial_FriendlyUnit;
var Material m_kAOEDamageMaterial_FriendlyDestructible;
var array<Vector> m_arrInitialUnitLocs;
var XComVolumeDuckingMgr m_kVolumeDuckingMgr;
var XComAlienPodManager m_kPodMgr;
var SoundCue EnemySpottedCue;
var XGProjectileManager m_kProjectileMgr;
var transient int SleepFrames;
var transient float TimeSpentWaitingForLoading;
var float fTimeoutTimer;
//var native const transient map<0,0> m_cStopTurnTimerActionsExecuting;
var int m_iNumStopTurnTimerActionsExecuting;


function UninitResults();
function UninitDescription();
function InitPlayers(optional bool bLoading=false){}
function AlienPlayerDeferredInit();
function InitRules();
function array<XComSpawnPoint> GetSpawnPoints(ETeam eUnitTeam, optional int iNumSpawnPoints){}
function CheckForVictory(optional bool bIgnoreBusy){}
simulated function XComPresentationLayer PRES();

function XGSquad GetEnemySquad(XGPlayer kPlayer);

function XGPlayer GetEnemyPlayer(XGPlayer kPlayer);

function XGPlayer GetAIPlayer();

simulated function XGPlayer GetLocalPlayer();

function InitVisiblity();

function InitLoadedItems();

function UpdateVisibility();

function bool TurnIsComplete();

function bool ReadyForNewTurn();

function BeginNewTurn(optional bool bIsLoading);

simulated function ClientBeginNewTurn();

function CompleteCombat();

function int GetDifficulty();
simulated function CameraIsMoving(XComTacticalController kPC){}
simulated function CameraMoveComplete(XComTacticalController kPC){}
simulated function bool IsCameraMoving(XComTacticalController kPC){}

// Export UXGBattle::execStartedExecutingStopTurnTimerAction(FFrame&, void* const)
native function StartedExecutingStopTurnTimerAction(XGAction kAction);

// Export UXGBattle::execFinishedExecutingStopTurnTimerAction(FFrame&, void* const)
native function FinishedExecutingStopTurnTimerAction(XGAction kAction);

// Export UXGBattle::execNotifyKismetOfBattle(FFrame&, void* const)
native function NotifyKismetOfBattle();
function bool IsBattleDone(optional bool bIgnoreBusy){}
function AbandonBattle(bool bAbandon){}
simulated event ReplicatedEvent(name VarName){}
simulated function bool ProfileSettingsSaveDataIsValid(){}
simulated function XComOnlineProfileSettings GetProfileSettings(){}
simulated function SetProfileSettings(){}
simulated function bool ProfileSettingsAutoSave(){}
simulated function bool ProfileSettingsMuteSoundFX(){}
simulated function bool ProfileSettingsMuteMusic(){}
simulated function bool ProfileSettingsMuteVoice(){}
simulated function bool ProfileSettingsThirdPersonCam(){}
simulated function bool ProfileSettingsGlamCam(){}
simulated function bool ProfileSettingsActivateMouse(){}
simulated function ProfileSettingsDebugUseController(){}
simulated function float ProfileSettingsEdgeScrollRate(){}
simulated function XGGameData.ECharacter ProfileSettingsAlienType(){}
simulated function int ProfileSettingsPodGroup(){}
simulated function GetProfileSettingsCivilianContent(out TCivilianPawnContent CivilianContent){}
simulated function bool IsTurnTimerCloseToExpiring(optional float fThresholdSeconds){}
function bool IsAlienTurn(){}
simulated function array<XGGameData.EPawnType> GetPawnTypes(ETeam eUnitTeam){}
simulated function InitAmbientAudio(){}
function ReplicateLoadoutInfo(ETeam _eTeam, const out array<XGGameData.EPawnType> arrPawnTypes, const out array<XGGameData.ELoadoutTypes> arrLoadoutTypes){}
function InitResults(){}
function InitDescription();
simulated function InitLevel(){}
simulated function PostLevelLoaded(){};
function AddPlayer(XGPlayer Player){}
function Uninit(){}
function SwapTeams(XGUnit pUnit, optional bool bSkipTurn, optional ETeam eForceTeam){}
function XGSquad GetAnimalSquad(){}
simulated function bool InCloseEncounter(){}
function bool IsPlayerPanicking(){}
function DebugLogHang(){}
function bool IsWaitingOnCountdownMgr(){}
function Start(){}
function PostLoad(){}
function bool IsPaused(){}
function Play();
function Pause(){}
function bool IsVictory(bool bIgnoreBusyCheck){}
reliable client simulated function PlayCinTacticalOutro(XGUnit kUnit){}
simulated function ToggleFOW(){}
simulated function SetFOW(bool bNewFOW){}
simulated function SetEdge(bool bNewEdge){}
simulated function int GetSpawnGroup(optional out name groupTag){}
reliable client final simulated function int SortCinIntroSoldiers(XGUnit kUnit1, XGUnit kUnit2){}
reliable client simulated function PlayCinTacticalIntro(){}
static simulated function AddPawnToTacticalIntro(XComPawn kPawn, SeqEvent_OnTacticalIntro kIntro, out int iPlacedUnits, out int iPlacedMecs, out int iPlacedSoldiers, out int iPlacedShivs){}
simulated function RestoreIntroPawns(){}
simulated function DrawDebugLabel(Canvas kCanvas){}
simulated function EndSpecialFOWUpdate(){}
simulated function InitDifficulty(){}
simulated function ChangeDifficulty(int iNewDifficulty){}
function DoWorldDataRebuild(optional bool bUseIncreasedRateLimit=true){}
simulated function PostLoadSaveGame(){};
simulated function CheckReadyToHideLoadingScreen(optional bool bOverride){}
simulated function LoadDynamicAOEMaterials(){}
simulated function WaitForGameCoreInitializationToComplete();

simulated function WaitForInitializationToComplete();

simulated function WaitForRunningClients();
simulated function bool AtBottomOfRunningStateBeginBlock(){}
function CollectLoot(){}
function int GetRecoveredMeldAmount(){}
function QuitAndTransition(){}
function HideCiviliansNearLoc(Vector vHideLoc, float fSafeDistance);
function XGRecapSaveData GetStats(){}
function bool DidYouWin(){}
function int STAT_GetStat(XGGameData.ERecapStats eStat){}
function int STAT_AddStat(XGGameData.ERecapStats eStat, int iValue){}
function float STAT_AddAvgStat(XGGameData.ERecapStats eCountStat, XGGameData.ERecapStats eSumStat, int Value){}
function int STAT_SetStat(XGGameData.ERecapStats eStat, int iValue){}
function STAT_AddProfileStat(XGGameData.EProfileStats eStat, float fValue){}
function STAT_SetProfileStat(XGGameData.EProfileStats eStat, float fValue){}
function float STAT_GetProfileStat(XGGameData.EProfileStats eStat){}
function InvalidPathSelection(XGUnit ActiveUnit){}
simulated function EnsureAbortDialogClosedAtEndOfLowFriends(){}
simulated state Starting
{
    function LoadSoldierContentForRestart()
	{}
}
simulated state RebuildingWorldData
{}
simulated state LevelCinematicIntro
{
    function SetupCamera()
	{}
}

simulated state Initing
{    
	simulated function bool WaitingForUnitVisualization()
	{}
}
simulated state StartUI
{}
state Loading
{   
	function NotifyKismetOfLoad()
	{}
	    function RequestAlienContentOnLoad(){}
    function SetupCamera(){}

}
simulated state Running{}
state Paused
{}
state TransitioningPlayers
{}
simulated state ModalUI
{}
simulated state Done
{}
