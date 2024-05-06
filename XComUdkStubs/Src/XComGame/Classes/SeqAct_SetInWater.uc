class SeqAct_SetInWater extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var() bool bInWater;
var() float fWaterZ;
var() array<ParticleSystem> InWaterParticles;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target XComUnitPawn",PropertyName=TargetActor)
    ObjName="SetInWater"
}