class SeqAct_Ragdoll extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var() bool bDoPhysicsMotors;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    ObjName="Ragdoll"
}