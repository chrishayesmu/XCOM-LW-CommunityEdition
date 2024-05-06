class SeqAct_DebugOutput extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var string DebugText;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Debug Text",PropertyName=DebugText)
    VariableLinks(1)=(LinkDesc="Debug Values")
    ObjName="Debug Output"
}