class SeqAct_SetEnemyPosition extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Object EnemyUnit;
var Object NewLocation;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Enemy Unit",PropertyName=EnemyUnit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="New Location",PropertyName=NewLocation)
    ObjName="Set Enemy Position"
}