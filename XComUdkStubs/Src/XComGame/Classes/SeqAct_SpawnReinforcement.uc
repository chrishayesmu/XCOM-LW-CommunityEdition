class SeqAct_SpawnReinforcement extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool SpawnBlueshirt;
var private XGUnit SpawnedUnit;
var private Pawn UnitPawn;
var private XComSpawnPoint OriginPoint;
var private XComSpawnPoint DestinationPoint;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Origin Point",PropertyName=OriginPoint,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Destination Point",PropertyName=DestinationPoint,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawned Unit",PropertyName=SpawnedUnit,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="Spawn Reinforcement"
}