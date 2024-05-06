class SeqAct_KillUnit extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var Actor ShooterActor;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Killed By",PropertyName=ShooterActor)
    ObjName="Kill Unit"
}