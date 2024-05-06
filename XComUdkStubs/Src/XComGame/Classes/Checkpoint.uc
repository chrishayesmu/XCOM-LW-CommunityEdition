class Checkpoint extends Object
    native(Core)
    config(Checkpoint);

struct native ActorRecord
{
    var string ActorPathName;
    var string ActorName;
    var Vector ActorPosition;
    var Rotator ActorRotation;
    var string ActorClassPath;
    var int TemplateIndex;
    var array<byte> RecordData;
};

struct native ActorTemplateInfo
{
    var string ActorClassPath;
    var string ArchetypePath;
    var byte LoadParams[64];
    var bool UseTemplate;
    var Class ActorClass;
    var Actor Template;
};

var const localized string DisplayName;
var Class MyClass;
var int SlotIndex;
var string BaseLevelName;
var string GameType;
var array<ActorRecord> ActorRecords;
var array<Object> ActorRecordClasses;
var array<byte> KismetData;
var array<name> ActorNames;
var array<name> ClassNames;
var array<ActorTemplateInfo> ActorTemplates;
var const array< class<Actor> > ActorClassesToRecord;
var const array< class<Actor> > ActorClassesToDestroy;
var const array< class<Actor> > ActorClassesNotToDestroy;
var const bool IsMapSave;
var array< class<Actor> > OnlyApplyActorClasses;
var int SyncSeed;
var int CheckpointVersion;

delegate PostSaveCheckpointCallback()
{
}

delegate PostLoadCheckpointCallback()
{
}