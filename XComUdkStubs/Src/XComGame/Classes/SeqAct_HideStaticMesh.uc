class SeqAct_HideStaticMesh extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    InputLinks(0)=(LinkDesc="Hide")
    InputLinks(1)=(LinkDesc="Unhide")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Static Mesh",PropertyName=Targets)
    ObjName="Hide/Unhide Static Mesh"
}