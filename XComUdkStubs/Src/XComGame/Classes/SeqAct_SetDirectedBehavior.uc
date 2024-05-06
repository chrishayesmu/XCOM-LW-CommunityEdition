class SeqAct_SetDirectedBehavior extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Object EnemyUnit;
var XComDirectedTacticalExperience DTE;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Enemy Unit",PropertyName=EnemyUnit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Directed Tactical Environment",PropertyName=DTE)
    ObjName="Set Enemy Directed Tactical Environment"
}