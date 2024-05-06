class XComDestructibleActor extends XComLevelActor
    native(Destruction)
    hidecategories(Navigation)
    implements(Destructible);

const DestructibleActorDamagedThreshold = 0.75;

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

defaultproperties
{
    Health=1
    bDestroysSurroundingArea=true
    TotalHealth=1
    TimeBeforeDeath=10.0
    DestroyedDamageClass=class'XComDamageType_DestructibleActorClear'
    StateNames[0]=_Pristine
    StateNames[1]=_Damaged
    StateNames[2]=_Destroyed
    StateNames[3]=Dead
    bCanClimbOnto=false
    bBlocksNavigation=true
    bProjTarget=true
    bBlocksTeleport=true
    bNoEncroachCheck=true
    bPathColliding=false

    SupportedEvents.Add(Class'SeqEvent_Touch')
    SupportedEvents.Add(Class'SeqEvent_Destroyed')
    SupportedEvents.Add(Class'SeqEvent_TakeDamage')
    SupportedEvents.Add(Class'SeqEvent_HitWall')
    SupportedEvents.Add(Class'SeqEvent_AnimNotify')
    SupportedEvents.Add(Class'SeqEvent_MobileTouch')
    SupportedEvents.Add(Class'SeqEvent_DestructibleStatusChanged')

    begin object name=StaticMeshComponent0
        WireframeColor=(R=0,G=255,B=128,A=255)
        ReplacementPrimitive=none
        RBChannel=RBCC_GameplayPhysics
        LightingChannels=(bInitialized=true,Static=true,Dynamic=true)
        RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
    end object

    begin object name=MyNEWLightEnvironment class=DynamicLightEnvironmentComponent
        bCastShadows=false
        bUseBooleanEnvironmentShadowing=false
        bDynamic=false
        bEnabled=false
        bForceNonCompositeDynamicLights=true
    end object

    LightEnvironment=MyNEWLightEnvironment
    Components.Add(MyNEWLightEnvironment)
}