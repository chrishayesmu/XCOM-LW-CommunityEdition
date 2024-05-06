class SeqAct_ToggleFOW extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var bool bToggle;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Reveal Map ( FOW Never Seen to Have Seen )",PropertyName=bToggle)
    ObjName="Reveal Map ( FOW Never Seen to Have Seen )"
}