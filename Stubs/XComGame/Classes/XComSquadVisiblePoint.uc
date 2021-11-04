class XComSquadVisiblePoint extends Actor
    hidecategories(Navigation)
    placeable;
//complete stub

struct CheckpointRecord
{
    var bool TriggeredNarrative;
};

var export editinline SpriteComponent VisualizeSprite;
var() XComNarrativeMoment Narrative;
var protected bool TriggeredNarrative;
var() bool bHighPriorityCamera;
var XGAction_NarrativeLookAt kAction;
var() name nmRemoteEventToTrigger;
var() name nmRemoteEventToTriggerOnNarrativeComplete;
var() float fMinSightPercent;

simulated function MarkAsTriggered(){}
simulated event PostBeginPlay(){}
simulated event Tick(float dt){}
