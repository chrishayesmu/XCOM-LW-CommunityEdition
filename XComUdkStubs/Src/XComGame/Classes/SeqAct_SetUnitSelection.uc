class SeqAct_SetUnitSelection extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor TargetActor;
var() bool ForceSelection;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=TargetActor)
    ObjName="Set Unit Selection"
}