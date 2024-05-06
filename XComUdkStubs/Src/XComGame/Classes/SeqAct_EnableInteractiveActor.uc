class SeqAct_EnableInteractiveActor extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Enable")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="XComInteractiveLevelActor",PropertyName=Targets)
    ObjName="Enable Interactive Actor"
}