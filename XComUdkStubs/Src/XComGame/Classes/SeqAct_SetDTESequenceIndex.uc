class SeqAct_SetDTESequenceIndex extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XComDirectedTacticalExperience DirectedExperience;
var() int Index;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Directed Tactical Environment",PropertyName=DirectedExperience)
    ObjName="Set Squence Index"
}