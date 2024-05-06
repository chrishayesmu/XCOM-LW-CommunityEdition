class XComSpecialMissionHandler_Templeship extends XComSpecialMissionHandler
    notplaceable
    hidecategories(Navigation);

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

    structdefaultproperties
    {
        Alien=none
        TimeToPlayEffects=0.0
        TimeToKill=0.0
    }
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

defaultproperties
{
    FirstArenaPods[0]=FirstArenaPod0
    FirstArenaPods[1]=FirstArenaPod1
    FirstArenaPods[2]=FirstArenaPod2
    FirstArenaPods[3]=FirstArenaPod3
    FirstArenaPods[4]=FirstArenaPod4
    FirstArenaPods[5]=FirstArenaPod5
    FirstArenaPods[6]=FirstArenaPod6
    SecondArenaPods[0]=SecondArenaPod0
    SecondArenaPods[1]=SecondArenaPod1
    SecondArenaPods[2]=SecondArenaPod2
    SecondArenaPods[3]=SecondArenaPod3
    SecondArenaPods[4]=SecondArenaPod4
    SecondArenaPods[5]=SecondArenaPod5
    SecondArenaPods[6]=SecondArenaPod6
    LiveAliensThreshold=-1
    AlienDeathEffectName="FX_Psionics_Ethereal.P_Alien_Removal_Vortex"
}