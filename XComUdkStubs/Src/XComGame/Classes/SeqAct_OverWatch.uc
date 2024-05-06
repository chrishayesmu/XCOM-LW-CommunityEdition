class SeqAct_OverWatch extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XGUnit TargetUnit;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Unit",PropertyName=TargetUnit)
    ObjName="OverWatch"
}