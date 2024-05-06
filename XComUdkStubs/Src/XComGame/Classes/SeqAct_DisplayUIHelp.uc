class SeqAct_DisplayUIHelp extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() string Message;
var() string MessagePC;
var() float DisplayTime;

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Show")
    InputLinks(1)=(LinkDesc="Hide")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Display Message",PropertyName=Message)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Display Time",PropertyName=DisplayTime,bWriteable=true)
    ObjName="UI Help"
}