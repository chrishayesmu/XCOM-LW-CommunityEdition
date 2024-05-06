class SeqAct_SkipAI extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var bool bSkipAI;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Skip AI",PropertyName=bSkipAI)
    ObjName="Skip AI"
}