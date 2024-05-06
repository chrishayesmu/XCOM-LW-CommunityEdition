class SeqAct_SetUnitTarget extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Object FiringActor;
var Object TargetActor;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Firing Unit",PropertyName=FiringActor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Unit",PropertyName=TargetActor)
    ObjName="Set Unit Target"
}