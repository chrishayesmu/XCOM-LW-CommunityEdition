class XComSpecialMissionHandler_Templeship extends XComSpecialMissionHandler;
//complete stub

const AlienDeferKillTime = 2.0;

struct CheckpointRecord_XComSpecialMissionHandler_Templeship extends CheckpointRecord
{
    var bool bSpawnedFirstArenaPods;
    var bool bSpawnedSecondArenaPods;
    var bool bSpawnedBossArenaPods;
    var int LiveAliensThreshold;
    var int PrevAlienSquadSize;
    var int NumDeadEthereals;
    var bool bInWinningState;
    var bool bUE_WoundedSpoke;
    var bool bUE_GravelyWoundedSpoke;
};

struct PendingKillAlien
{
    var XGUnit Alien;
    var float TimeToPlayEffects;
    var float TimeToKill;
};

var const name FirstArenaPods[7];
var const name SecondArenaPods[7];
var bool bSpawnedFirstArenaPods;
var bool bSpawnedSecondArenaPods;
var bool bSpawnedBossArenaPods;
var bool bClearedContentForFinalBattle;
var bool bInWinningState;
var bool bWatchingAliens;
var bool bMoveToNextStateRequested;
var bool bUE_WoundedSpoke;
var bool bUE_GravelyWoundedSpoke;
var SeqVar_Bool FirstSwarmTriggeredOnce;
var SeqVar_Bool SecondSwarmTriggeredOnce;
var SeqVar_Bool SpawnFinalAliensOnce;
var int LiveAliensThreshold;
var int PrevAlienSquadSize;
var array<PendingKillAlien> UnitsToRemove;
var int NumDeadEthereals;
var init const string AlienDeathEffectName;
var float TimeEnteredDoWin;
var XGUnit UberEthereal;
var SeqVar_Bool LoadingStatus;
var SeqVar_Bool Gate1Open;

function Initialize(){}
function DeferredGotoStartState(){}
function TempleshipPeriodicUpdate(){}
function OnAlienAddedRemoved(){}
function OnUberDamaged(){}
function OnAlienTypeSeen(){}
function SpawnArenaPods(name VariableNames[7]){}
function OnAlienUnitDamaged(){}
function RemoveAlienUnit(){}
function DoWin(){}
function MoveToNextState(){}

auto state WaitForInitialState
{
}
state FirstArena
{
    function MoveToNextState()
    {
        GotoState('FirstArena_Wave1');
    }
}
state FirstArena_Wave1
{
    function MoveToNextState()
    {
    }
}
state FirstArena_Wave2
{
    function MoveToNextState()
    {
    }
}
state SecondArena
{
    function MoveToNextState()
	{}
}
state BossArena
{
}
state WinInitiated
{
}
state AllUnitsLost
{
}