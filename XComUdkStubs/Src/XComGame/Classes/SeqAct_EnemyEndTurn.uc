class SeqAct_EnemyEndTurn extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Object EnemyUnit;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Enemy Unit",PropertyName=EnemyUnit)
    ObjName="Enemy End Turn"
}