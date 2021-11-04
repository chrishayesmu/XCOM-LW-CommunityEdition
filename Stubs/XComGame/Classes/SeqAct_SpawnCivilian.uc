class SeqAct_SpawnCivilian extends SequenceAction
     hidecategories(Object);

var() bool bEnabled;
var() bool bFemale;
var() bool bUnitFlag;
var() bool bDrawProximityRing;
var() name TemplateName;
var() int iHP;
var XGUnit SpawnedUnit;
var XComCivilian SpawnedPawn;

event Activated()
{
}


defaultproperties
{
    bEnabled=true
    bUnitFlag=true
    bDrawProximityRing=true
    iHP=3
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="SpawnPoints")
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawned Civilian Unit",PropertyName=SpawnedUnit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawned Civilian Pawn",PropertyName=SpawnedPawn,bWriteable=true)
    ObjName="Spawn Civilian"
}