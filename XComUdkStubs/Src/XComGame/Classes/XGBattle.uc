class XGBattle extends Actor
    abstract
    native(Core)
    notplaceable
    hidecategories(Navigation);

const TIMEOUT_TIME = 60.0f;
const GANGPLANK_ELERIUM_REWARD = 300;
const GANGPLANK_ALLOYS_REWARD = 500;

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
    var XGPlayer m_arrPlayers[ENumPlayers];
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
var XGPlayer m_arrPlayers[ENumPlayers];
var repnotify int m_iTurn;
var int m_iNumPlayers;
var protectedwrite int m_iNumHumanPlayers;
var repnotify int m_iPlayerTurn;
var protected XGBattleResult m_kResults;
var TPawnContent Content;
var StrategyGameTransport m_kTransferSave;
var protected XComOnlineProfileSettings m_kProfileSettings;
var string m_strObjective;
var int m_iResult;
var bool m_iResultCachedThisFrame;
var bool m_bIsInited;
var bool m_bLoadingSave;
var bool m_bSkipVisUpdate;
var bool m_bLevelStreamingComplete;
var bool m_bShowLoadingScreen;
var protected repnotify bool m_bClientStart;
var protected bool m_bClientAlreadyStarted;
var bool m_bCloseCombatFromPodMovement;
var bool m_bTacticalIntroDone;
var bool m_bHQAssaultIntroDone;
var bool m_bFoundTacticalIntro;
var bool m_bPlayerTransition;
var bool m_bPlayCinematicIntro;
var bool m_bLoadKismetDataFromSave;
var const bool m_bAllowItemFragments;
var private bool m_bSkipOuttroUI;
var bool m_bInPauseMenu;
var private transient bool m_bAtBottomOfRunningStateBeginBlock;
var private transient bool m_bServerAtBottomOfRunningStateBeginBlock;
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
var private native const transient Map_Mirror m_cStopTurnTimerActionsExecuting;
var privatewrite int m_iNumStopTurnTimerActionsExecuting;

defaultproperties
{
    m_bShowLoadingScreen=true
    m_bPlayCinematicIntro=true
    m_bAllowItemFragments=true
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=true
}