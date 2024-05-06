class SeqAct_SpecialMissionHandler_SetObjectiveText extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var string ObjectiveText;
var string ObjectiveText_1;
var string ObjectiveText_2;
var string ObjectiveText_3;
var string ObjectiveText_4;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Objective 1",PropertyName=ObjectiveText)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Objective 2",PropertyName=ObjectiveText_1)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Objective 3",PropertyName=ObjectiveText_2)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Objective 4",PropertyName=ObjectiveText_3)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Objective 5",PropertyName=ObjectiveText_4)
    ObjName="Special Mission Handler Set Objective Text"
}