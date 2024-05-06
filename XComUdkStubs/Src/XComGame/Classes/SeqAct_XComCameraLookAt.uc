class SeqAct_XComCameraLookAt extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var() float ZoomLevel;
var() bool bHighPriority;

defaultproperties
{
    ZoomLevel=1.0
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Zoom Level",PropertyName=ZoomLevel)
    ObjName="Camera LookAt"
}