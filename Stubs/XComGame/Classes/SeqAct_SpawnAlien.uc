class SeqAct_SpawnAlien extends SequenceAction
    dependsOn(XGGameData);

var() XGGameData.EPawnType ForceAlienType;
var() bool bEnabled;
var() bool bUseOverwatch;
var() bool bTriggerOverwatch;
var bool bPlaySound;
var() bool bRevealSpawn;
var() bool bSpawnImmediately;
var() int iDropHeight;
var() SoundCue kAdditionalSound;
var XGUnit SpawnedUnit;
var XGAISpawnMethod_DropIn m_kDropIn;

event Activated()
{
}

defaultproperties
{
    bEnabled=true
    bCallHandler=false
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    OutputLinks(0)=(LinkDesc="Out")
    OutputLinks(1)=(LinkDesc="Fully Spawned")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="SpawnPoints")
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawned Alien",PropertyName=SpawnedUnit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Play Sound",PropertyName=bPlaySound,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Reveal Spawn",PropertyName=bRevealSpawn,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Spawn Immediately",PropertyName=bSpawnImmediately)
    ObjName="Spawn Alien"
}
