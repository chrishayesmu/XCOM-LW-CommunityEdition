class SeqAct_MoveToLocation extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XGUnit TargetUnit;
var Object LocationObj;
var() bool UseClosestCoverPoint;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit to Move",PropertyName=TargetUnit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Location",PropertyName=LocationObj)
    ObjName="Move To Location"
}