class XComWaveSystem extends Actor
    native(AI)
    placeable
    hidecategories(Navigation,Movement,Display,Attachment,Actor,Collision,Physics,Advanced,Debug);

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

    structdefaultproperties
    {
        DropHeight=768
    }
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

    structdefaultproperties
    {
        Hunter=true
    }
};

struct native AlienWave
{
    var() int TurnAppearance;
    var() ESpawnTime SpawnTime;
    var() array<AlienGroup> Groups;
    var bool bSpawned;

    structdefaultproperties
    {
        TurnAppearance=-1
    }
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