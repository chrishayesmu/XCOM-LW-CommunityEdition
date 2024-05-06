class SeqAct_DisplayMissionObjective extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var string Message;
var string Id;

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Show Incomplete")
    InputLinks(1)=(LinkDesc="Show Complete")
    InputLinks(2)=(LinkDesc="Remove")
    InputLinks(3)=(LinkDesc="Show Failed")
    InputLinks(4)=(LinkDesc="Hide Checkbox")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Message",PropertyName=Message)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Unique ID",PropertyName=Id)
    ObjName="Display Mission Objective"
}