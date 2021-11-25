class XComDestructibleDebrisManager extends Actor
    native
    notplaceable
    hidecategories(Navigation);

struct native RemainsRequestStruct
{
    var Actor pTemplateActor;
    var Vector NewLocation;
    var Rotator NewRotation;
    var LightingChannelContainer NewLightingChannels;
    var string TemplatePath;
};

struct CheckpointRecord
{
    var array<RemainsRequestStruct> SpawnedDebrisRequests;
};

var private native const noexport Pointer VfTable_FTickableObject;
var array<StaticMeshActor> m_DebrisCoverActors;
var int MaxNumberOfSpawnedDebris;
var array<RemainsRequestStruct> RequestRemains;
var array<RemainsRequestStruct> SpawnedDebrisRequests;

function bool ShouldSaveForCheckpoint(){}
function CreateCheckpointRecord(){}
function ApplyCheckpointRecord(){}