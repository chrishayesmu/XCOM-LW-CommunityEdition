class SeqAct_ToggleUIVisibility extends SequenceAction
    native
    forcescriptorder(true)
    hidecategories(Object);

var() bool bShow;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Show",PropertyName=bShow)
    ObjName="UI Show or Hide All"
}