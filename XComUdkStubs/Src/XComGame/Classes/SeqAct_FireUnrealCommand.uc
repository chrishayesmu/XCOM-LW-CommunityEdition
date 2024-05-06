class SeqAct_FireUnrealCommand extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var int Cmd;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="cmd",PropertyName=Cmd,bWriteable=true)
    ObjName="Fire OnUnrealCommand"
}