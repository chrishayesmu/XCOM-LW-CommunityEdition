class SeqAct_XComPawnToUnit extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XGUnit TargetUnit;
var Actor TargetActor;

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="XComPawn",PropertyName=Targets)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="XGUnit",PropertyName=TargetUnit,bWriteable=true)
    ObjName="XComPawnToUnit"
}