class SeqAct_ToggleBuildingReveal extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Enable")
    InputLinks(1)=(LinkDesc="Disable")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Volumes")
    ObjName="Toggle Building Reveal"
}