class XComMeldContainerActor extends XComFriendlyDestructibleSkeletalMeshActor
    native(Destruction)
    config(GameData)
    hidecategories(Navigation)
    implements(XComInteractiveLevelActorInteractionHandler);

enum EMeldInteractionAnim
{
    eMeld_Idle,
    eMeld_Crush,
    eMeld_CrushedState,
    eMeld_Open,
    eMeld_OpenState,
    eMeld_MAX
};

struct CheckpointRecord_XComMeldContainerActor extends CheckpointRecord
{
    var XComMeldContainerSpawnPoint m_kSpawnPoint;
    var bool m_bHasBeenSeen;
    var bool m_bCollected;
    var bool m_bPerceivedLastTurn;
    var int m_iTurnsUntilDestroyed;
    var EMeldInteractionAnim m_eLastInteractionAnim;
};

var const config int m_iMeldAwardedPerContainer;
var XComInteractiveLevelActor m_kInteractiveLevelActor;
var export editinline AudioComponent m_kLoopCueComponent;
var XComMeldContainerSpawnPoint m_kSpawnPoint;
var bool m_bHasBeenSeen;
var bool m_bVisibleToSquad;
var bool m_bCollected;
var bool m_bPerceivedLastTurn;
var int m_iTurnsUntilDestroyed;
var int m_iVictoryResultChangeWatchHandle;
var const localized string m_strMeldCollectedFlyoverText;
var() SoundCue m_kLoopFastCue;
var() SoundCue m_kLoopMediumCue;
var() SoundCue m_kLoopSlowCue;
var() SoundCue m_kMeldBreakCue;
var() SoundCue m_kPowerDownCue;
var() name AnimNodeName;
var transient AnimNodeBlendList AnimNode;
var EMeldInteractionAnim m_eLastInteractionAnim;

simulated function OnTurnChanged();
private final simulated function OnVictoryResultChanged();
simulated function OnInteraction(XGUnit kUnit, XComInteractiveLevelActor kEventInstigator);
native simulated function UpdateSquadVisibility();
simulated event OnFirstTimeSeen(XGUnitNativeBase kUnitThatSawMe);
simulated function InitFromSpawnPoint(XComMeldContainerSpawnPoint kSpawnPoint){}
simulated function InitFromSave(){}
function ApplyCheckpointRecord(){}
function SetActorTemplateInfo(out ActorTemplateInfo TemplateInfo);
function CreateCheckpointRecord(){}
simulated function DetermineToughness(){}
simulated function int GetMeldAmount(){}

simulated function CreateInteractiveLevelActor(Vector vLocation){}
simulated function bool IsDestroyed(){}
simulated function bool IsCollected(){}
simulated function DoRemoteEvent(name nEventName){}
simulated function DrawMeldCollectedWorldMessage(){}
function bool ShouldSaveForCheckpoint(){}
simulated function UpdateLoopCueComponent(){}
simulated event PostBeginPlay(){}
simulated event Destroyed(){}
simulated function SetInteractionAnim(EMeldInteractionAnim eAnim){}
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){}
event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime){}

auto simulated state _Pristine
{
	simulated event BeginState(name PreviousStateName){}
	simulated event EndState(name NextStateName);
	simulated event Tick(float DeltaTime){}
	simulated function OnInteraction(XGUnit kUnit, XComInteractiveLevelActor kEventInstigator){}
	simulated function OnVictoryResultChanged(){}
	simulated function OnTurnChanged(){}
	simulated function AttemptPerception(){}
	simulated event OnFirstTimeSeen(XGUnitNativeBase kUnitThatSawMe){}
}
simulated state _Expired
{
    simulated event BeginState(name nPreviousState){}
    simulated function bool IsDestroyed(){}
}
simulated state _Destroyed
{
    simulated event BeginState(name nPreviousState){}
    simulated function bool IsDestroyed(){}
}
simulated state Dead
{
    simulated function bool IsDestroyed(){}
}