class SeqAct_GetDTESeqNum extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var int CurrentIndex;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target",PropertyName=Targets)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="CurrentIndex",PropertyName=CurrentIndex,bWriteable=true)
    ObjName="Get DTE Sequence Num"
}