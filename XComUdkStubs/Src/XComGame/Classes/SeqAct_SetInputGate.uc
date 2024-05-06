class SeqAct_SetInputGate extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var int Cmd;
var bool bReport;
var bool bLocked;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="cmd",PropertyName=Cmd,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="bReportToKismet",PropertyName=bReport,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="bLock",PropertyName=bLocked,bWriteable=true)
    ObjName="Set Input Gate"
}