class XComDestructibleActor extends XComLevelActor
    native(Destruction);
//complete stub

struct native DestructibleActorEvent
{
    var() float Time;
    var() int Turns;
    var() export editinline XComDestructibleActor_Action Action;
    var() editoronly string Comment;
};

struct CheckpointRecord
{
    var int Health;
    var int TotalHealth;
    var DamageEvent LastDamage;
    var int FirstTurnInState;
    var float TimeInState;
    var array<int> DamagedEventActivates;
    var array<int> DestroyedEventActivates;
    var array<int> DamageEventTurnToApplyDamages;
    var name SavedStateName;
    var string LastDamageClass;
    var transient bool bDoCameraPan;
};

var private native const noexport Pointer VfTable_IDestructible;
var transient int Health;
var editinline deprecated array<editinline deprecated XComDestructibleActor_Action> DamagedActions;
var editinline deprecated array<editinline deprecated XComDestructibleActor_Action> DestroyedActions;
var() editinline array<editinline DestructibleActorEvent> DamagedEvents;
var() editinline array<editinline DestructibleActorEvent> DestroyedEvents;
var transient array<DestructibleActorEvent> DamagedEventsChangeBuffer;
var transient array<DestructibleActorEvent> DestroyedEventsChangeBuffer;
var transient bool InEditOperation;
var(Collision) const bool bIgnoreForPathing;
var(Interaction) const bool bInteractive;
var() const bool bDestroysSurroundingArea;
var transient bool bDoCameraPan;
var transient bool bCameraReady;
var transient bool bDestroyBegun;
var transient bool bLoadedFromSave;
var transient bool bCurrentStateRequiresTick;
var() bool bReuseOriginalMeshLightMap;
var transient int DamagedEventsChangeSize;
var transient int DestroyedEventsChangeSize;
var array<int> DamagedEventActivates;
var array<int> DestroyedEventActivates;
var array<int> DamageEventTurnToApplyDamages;
var name SavedStateName;
var() XComDestructibleActor_Toughness Toughness;
var() array<XComDestructibleActor> AffectedChildren;
var transient int TotalHealth;
var DamageEvent LastDamage;
var() array<MaterialInstanceConstant> m_kAOEDamageMaterial;
var transient float TimeInState;
var transient int FirstTurnInState;
var transient int TurnsInState;
var() float TimeBeforeDeath;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var() editconst class<XComDamageType> DestroyedDamageClass;
var const name StateNames[4];
var transient string LastDamageClass;

function bool ShouldSaveForCheckpoint(){}
function CreateCheckpointRecord(){}
function ApplyCheckpointRecord(){}
simulated event PostBeginPlay(){}
native simulated function bool ShouldIgnoreForCover();
simulated function ApplyDamageToMe(const out DamageEvent Dmg){}
simulated function SpeakWarning(){}
simulated function bool IsReadyToExplode(){}
function bool HasRadialDamage(){}
simulated event TakeDirectDamage(const DamageEvent Dmg){}
simulated event TakeSplashDamage(const DamageEvent Dmg){}
simulated event TakeCollateralDamage(Actor FromActor, int DamageAmount){}

// Export UXComDestructibleActor::execDisableCollision(FFrame&, void* const)
native simulated function DisableCollision();

// Export UXComDestructibleActor::execUpdateSMCWithSwapMeshes(FFrame&, void* const)
native function UpdateSMCWithSwapMeshes();

// Export UXComDestructibleActor::execSetStaticMesh(FFrame&, void* const)
native simulated function SetStaticMesh(StaticMesh NewMesh, optional Vector NewTranslation, optional Rotator NewRotation, optional Vector NewScale3D);

// Export UXComDestructibleActor::execTriggerEvents(FFrame&, void* const)
native simulated function int TriggerEvents(const out array<DestructibleActorEvent> Events);

// Export UXComDestructibleActor::execCleanupEvents(FFrame&, void* const)
native simulated function CleanupEvents(const out array<DestructibleActorEvent> Events);

// Export UXComDestructibleActor::execTickEvents(FFrame&, void* const)
native simulated function TickEvents(const out array<DestructibleActorEvent> Events, float DeltaTime);

// Export UXComDestructibleActor::execDamageSurroundingArea(FFrame&, void* const)
native simulated function DamageSurroundingArea();

// Export UXComDestructibleActor::execGetDesiredTickState(FFrame&, void* const)
native simulated function bool GetDesiredTickState();

native simulated function SyncChildStates(name NewState);

simulated function ForceDLELighting(){}

auto simulated state _Pristine
{
	simulated event Tick(float DeltaTime);
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
}

simulated state _DamageState
{
    simulated event BeginState(name PreviousStateName){}
}
simulated state _Damaged extends _DamageState
{
    simulated event BeginState(name PreviousStateName){}
    simulated function Tick(float DeltaTime){}
    simulated event EndState(name NextStateName){}

}
simulated state _Destroyed extends _DamageState
{
    simulated event BeginState(name PreviousStateName){}
    simulated function BeginDestroyed(){}
    simulated function Tick(float DeltaTime){}
    simulated event EndState(name NextStateName){}
}

simulated state Dead
{
	    simulated function Tick(float DeltaTime){};

    simulated event BeginState(name PreviousStateName){}
}

defaultproperties
{
}