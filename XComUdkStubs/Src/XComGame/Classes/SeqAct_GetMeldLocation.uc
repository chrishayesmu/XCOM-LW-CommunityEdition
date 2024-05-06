class SeqAct_GetMeldLocation extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Vector MeldLocation;
var float ZOffset;
var XComMeldContainerSpawnPoint SpawnPoint;

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Easy")
    InputLinks(1)=(LinkDesc="Hard")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Location",PropertyName=MeldLocation,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Z offset",PropertyName=ZOffset)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawn Point Actor",PropertyName=SpawnPoint)
    ObjName="Get Meld Location"
}