class SeqAct_SetDestructibleActorState extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum DestructibleActorState
{
    eDamaged,
    eDestroyed,
    DestructibleActorState_MAX
};

var Actor TargetActor;
var() DestructibleActorState SetState;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    ObjName="Set DestructibleActor State"
}