class SeqCond_IsHuman extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    OutputLinks(0)=(LinkDesc="True")
    OutputLinks(1)=(LinkDesc="False")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit")
    ObjName="Is Human"
}