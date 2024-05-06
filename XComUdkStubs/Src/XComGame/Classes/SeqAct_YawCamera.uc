class SeqAct_YawCamera extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() float Rotation;
var() bool bSetToThisRotation;

defaultproperties
{
    Rotation=45.0
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Relative")
    InputLinks(1)=(LinkDesc="Absolute")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Rotation",PropertyName=Rotation)
    ObjName="Yaw Camera"
}