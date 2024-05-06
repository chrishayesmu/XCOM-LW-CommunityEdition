class SeqEvent_OnDTELoaded extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var int CurrentIndex;

defaultproperties
{
    bPlayerOnly=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Instigator",bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="CurrentIndex",PropertyName=CurrentIndex,bWriteable=true)
    ObjName="On DTE Loaded"
}