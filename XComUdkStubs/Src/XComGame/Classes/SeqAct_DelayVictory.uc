class SeqAct_DelayVictory extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var bool bNoLongerDelayed;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Stop Delaying",PropertyName=bNoLongerDelayed)
    ObjName="Delay Victory"
}