class SeqAct_SpawnUnit extends SequenceAction
    native(Level)
    dependson(XGGameData)
    forcescriptorder(true)
    hidecategories(Object);

var() class<XGUnit> UnitClass;
var() ELoadoutTypes LoadoutType;
var() bool bFemale;
var private XGPlayer HumanPlayer;
var private int CurrentSpawnPoint;
var private XGUnit SpawnedUnit;
var private Pawn UnitPawn;

defaultproperties
{
    UnitClass=class'XGUnit'
    LoadoutType=ELoadoutTypes.eLoadout_Rifleman
    bCallHandler=false
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="SpawnPoint(s)")
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawned Unit",PropertyName=SpawnedUnit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="Spawn Unit"
}