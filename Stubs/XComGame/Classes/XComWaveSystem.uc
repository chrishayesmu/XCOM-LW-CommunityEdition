class XComWaveSystem extends Actor
    native(AI)
dependson(XGGameData);
//complete stub

enum ESpawnMethod
{
    eSpawnMethod_DropIn,
    eSpawnMethod_WalkIn,
    eSpawnMethod_FlyIn,
    eSpawnMethod_MAX
};

enum ESpawnTime
{
    eSpawnTime_BeginningOfAITurn,
    eSpawnTime_EndOfAITurn,
    eSpawnTime_MAX
};

struct native SpawnMethodData
{
    var() ESpawnMethod SpawnType;
    var() SoundCue AdditionalSoundCue;
    var() bool UseOverwatch;
    var() bool TriggerOverwatch;
    var() bool PlaySound;
    var() bool RevealSpawn;
    var() int DropHeight;
    var() bool SpawnImmediately;
    var() int AttackChanceOnSpawn;
};

struct native AlienGroup
{
    var() bool Scalable;
    var() EPawnType AlienType;
    var() int NumAliens;
    var() bool Hunter;
    var() array<XComSpawnPoint_Alien> SpawnPoints;
    var() array<XComSpawnPoint_Alien> OriginationPoints;
    var() SpawnMethodData SpawnMethod;
    var() name m_strOnGroupActivated;
    var() name m_strOnGroupSpawned;
    var() int Priority;
};

struct native AlienWave
{
    var() int TurnAppearance;
    var() ESpawnTime SpawnTime;
    var() array<AlienGroup> Groups;
    var bool bSpawned;
};

struct native AlienSet
{
    var() name EventName;
    var() name DisableEvent;
    var() array<AlienWave> Waves;
    var int iTurnStart;
    var bool bActive;
    var SeqAct_ActivateRemoteEvent kTriggerEvent;
    var SeqAct_ActivateRemoteEvent kDisableEvent;
    var bool bDone;
    var bool bTriggerEventTripped;
    var bool bDisableEventTripped;
};

struct CheckpointRecord
{
    var array<AlienSet> m_arrAlienSets;
    var bool m_bActive;
    var array<EPawnType> m_arrScalableList;
    var array<EPawnType> m_arrScalableFlyInList;
    var array<EPawnType> m_arrScalableDropInList;
    var bool m_bForceEliteExalt;
    var bool m_bExaltMap;
};

var() bool m_bEnabled;
var bool m_bActive;
var bool m_bForceEliteExalt;
var bool m_bExaltMap;
var bool m_bLoadInit;
var bool m_bLimitLoadedContent;
var() array<AlienSet> m_arrAlienSets;
var array<EPawnType> m_arrScalableList;
var array<EPawnType> m_arrScalableFlyInList;
var array<EPawnType> m_arrScalableDropInList;
var const array<EPawnType> m_arrExclusionList;
var array<EPawnType> m_arrLoadedAlienContent;
var array<EPawnType> m_arrPrioritizedWaveContentList;
var const array<EPawnType> m_arrFlyInTypes;
var const array<EPawnType> m_arrDropInTypes;
var const array<EPawnType> m_arrWalkInTypes;
var int LoadedContentLimit;
var string ContentLimitReplacementLog;

function CreateCheckpointRecord(){}
function ApplyCheckpointRecord(){}
simulated function ResetEventLinks(){}
function bool UpdateSetEventLinks(int iSet, out array<SequenceObject> arrEvents){}
function bool IsValid(){}
function bool IsActive(){}
function bool Init(){}
function AddCharTypeToScalableList(ECharacter iCharType){}
function InitScalableList(){}
function OnBeginTurn(){}
function OnEndTurn(){}
function UpdateActiveFlags(){}
function UpdateWaveSpawning(optional ESpawnTime eTime, optional bool UpdateStatusOnly){}
function SpawnWave(int iWave, int iSet){}
function RefreshWaveStatus(){}
function XGAISpawnMethod CreateSpawnMethod(SpawnMethodData kSpawnInfo, EPawnType eForceType, name strEventName){}
function SpawnGroup(AlienGroup kGroup){}
function EPawnType GetEliteExaltVersion(EPawnType eExalt){}
function SetScalingAliens(out AlienGroup kGroup){}
function bool IsAlienTypeAlreadyLoaded(EPawnType AlienType){}
function int GetNumAlienTypesLoaded(){}
function EvaluateGroupContentRequest(out AlienGroup kGroup){}
native function GeneratePrioritizedWaveContentList(int iWave, int iSet);
native function UpdateLoadedAlienContentArray();
function DelayWaveTurnAppearance(optional int NumTurns=1){}
simulated function DrawDebugLabel(Canvas kCanvas, int iX, int iY){}
simulated function DrawDebugLabelContentRequests(Canvas kCanvas, int iX, int iY){}

defaultproperties
{
    m_bEnabled=true
    m_bActive=true
    m_bLoadInit=true
    m_arrExclusionList(0)=237
    m_arrExclusionList(1)=42
    m_arrExclusionList(2)=0
    m_arrFlyInTypes(0)=188
    m_arrFlyInTypes(1)=42
    m_arrFlyInTypes(2)=0
    m_arrFlyInTypes(3)=0
    m_arrFlyInTypes(4)=0
    m_arrDropInTypes(0)=226
    m_arrDropInTypes(1)=42
    m_arrDropInTypes(2)=0
    m_arrDropInTypes(3)=0
    m_arrDropInTypes(4)=0
    m_arrDropInTypes(5)=0
    m_arrDropInTypes(6)=0
    m_arrDropInTypes(7)=0
    m_arrDropInTypes(8)=227
    m_arrDropInTypes(9)=42
    m_arrDropInTypes(10)=0
    m_arrDropInTypes(11)=0
    m_arrDropInTypes(12)=0
    m_arrDropInTypes(13)=0
    m_arrDropInTypes(14)=0
    m_arrDropInTypes(15)=0
    m_arrDropInTypes(16)=220
    m_arrWalkInTypes(0)=228
    m_arrWalkInTypes(1)=42
    m_arrWalkInTypes(2)=0
    LoadedContentLimit=6
    Components(0)=none
}