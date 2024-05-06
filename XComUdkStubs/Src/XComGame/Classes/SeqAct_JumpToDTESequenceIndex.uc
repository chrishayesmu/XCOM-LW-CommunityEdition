class SeqAct_JumpToDTESequenceIndex extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XComDirectedTacticalExperience DirectedExperience;
var XGUnit Unit1;
var XGUnit Unit2;
var XGUnit Unit3;
var XGUnit Unit4;
var Actor SpawnPoint1;
var Actor SpawnPoint2;
var Actor SpawnPoint3;
var Actor SpawnPoint4;
var() int Index;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Directed Tactical Environment",PropertyName=DirectedExperience)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit1",PropertyName=Unit1)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit2",PropertyName=Unit2)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit3",PropertyName=Unit3)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit4",PropertyName=Unit4)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawn Point1",PropertyName=SpawnPoint1)
    VariableLinks(6)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawn Point2",PropertyName=SpawnPoint2)
    VariableLinks(7)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawn Point3",PropertyName=SpawnPoint3)
    VariableLinks(8)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawn Point4",PropertyName=SpawnPoint4)
    ObjName="Jump To Squence Index"
}