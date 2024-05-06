class SeqAct_DisableInteractiveActor extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Disable")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="XComInteractiveLevelActor",PropertyName=Targets)
    ObjName="Disable Interactive Actor"
}