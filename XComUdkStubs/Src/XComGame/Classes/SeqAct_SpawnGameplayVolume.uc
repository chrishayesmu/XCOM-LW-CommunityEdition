class SeqAct_SpawnGameplayVolume extends SequenceAction
    dependson(XGTacticalGameCoreData)
    forcescriptorder(true)
    hidecategories(Object);

var Actor ShooterOrSpawnPoint;
var Vector SpawnLocation;
var() EVolumeType VolumeType;
var Actor SpawnedVolume;

defaultproperties
{
    VolumeType=EVolumeType.eVolume_Fire
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="Location of XGVolume",PropertyName=SpawnLocation)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shooter or Spawn Point",PropertyName=ShooterOrSpawnPoint)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawned Volume",PropertyName=SpawnedVolume,bWriteable=true)
    ObjName="Spawn Gameplay Volume"
}