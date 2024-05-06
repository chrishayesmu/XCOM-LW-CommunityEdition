class SeqAct_GetCurrentTurn extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var int CurrentTurn;
var int CurrentPlayerTurn;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Current Turn",PropertyName=CurrentTurn,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Current Player Turn",PropertyName=CurrentRound,bWriteable=true)
    ObjName="Get Current Turn"
}