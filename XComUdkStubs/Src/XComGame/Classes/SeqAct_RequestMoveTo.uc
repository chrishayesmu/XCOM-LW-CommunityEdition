class SeqAct_RequestMoveTo extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor Target;
var Object MoveUnit;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Move Unit",PropertyName=MoveUnit,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target",PropertyName=Target,bWriteable=true)
    ObjName="Request Move To"
}