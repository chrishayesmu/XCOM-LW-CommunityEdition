class SeqEvent_OnReceiveUnrealCommand extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var int Cmd;
var bool bIsActive;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="bIsActive",PropertyName=bIsActive,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="cmd",PropertyName=Cmd,bWriteable=true)
    ObjName="On Receive OnUnrealCommand"
}