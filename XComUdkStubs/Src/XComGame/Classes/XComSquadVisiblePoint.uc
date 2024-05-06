class XComSquadVisiblePoint extends Actor
    placeable
    hidecategories(Navigation);

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

defaultproperties
{
    fMinSightPercent=0.750
    bNoDelete=false
    bStatic=false

    begin object name=Sprite class=SpriteComponent
        HiddenGame=true
    end object

    VisualizeSprite=Sprite
    Components.Add(Sprite)
}