class SeqAct_DestroyGameplayVolume extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XGVolume VolumeToDestroy;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Volume To Destroy",PropertyName=VolumeToDestroy)
    ObjName="Destroy Gameplay Volume"
}