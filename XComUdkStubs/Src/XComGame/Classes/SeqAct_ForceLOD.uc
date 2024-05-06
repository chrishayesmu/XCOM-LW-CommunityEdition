class SeqAct_ForceLOD extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var() name Tag;
var() int iLOD;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    ObjName="Force LOD"
}