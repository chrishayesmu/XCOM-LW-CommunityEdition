class SeqAct_ChangeBehavior extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Object EnemyUnit;
var() class<XGAIBehavior> NewBehavior;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Enemy Unit",PropertyName=EnemyUnit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="New Behavior",PropertyName=NewBehavior)
    ObjName="Change AI Behavior"
}