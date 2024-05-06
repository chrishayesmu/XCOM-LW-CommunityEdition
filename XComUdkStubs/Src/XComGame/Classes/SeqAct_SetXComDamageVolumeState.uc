class SeqAct_SetXComDamageVolumeState extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum FireState
{
    eOnFire,
    eFireExtinquished,
    FireState_MAX
};

var Actor TargetVolume;
var() FireState SetState;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Volume",PropertyName=TargetVolume)
    ObjName="Set XComDamageVolume State"
}