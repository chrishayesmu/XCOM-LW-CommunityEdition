class SeqAct_TeleportTo extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XGUnit Unit;
var Actor SpawnPoint;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=Unit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawn Point",PropertyName=SpawnPoint)
    ObjName="Teleport Unit To Location"
}