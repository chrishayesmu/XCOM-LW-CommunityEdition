class SeqAct_DisplayUIMessageBoxTimed extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var string Message;
var float DisplayTime;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Display Message",PropertyName=Message)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Display Time",PropertyName=DisplayTime,bWriteable=true)
    ObjName="UI Message Box"
}