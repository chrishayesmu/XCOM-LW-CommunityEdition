// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class SeqAct_HunkerDown extends SequenceAction
	forcescriptorder(true)
	hidecategories(Object);

var XGUnit TargetUnit;

event Activated()
{
}

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Unit",PropertyName=TargetUnit)
    ObjName="Hunker Down"
}
