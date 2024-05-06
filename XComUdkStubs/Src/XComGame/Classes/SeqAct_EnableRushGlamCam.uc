class SeqAct_EnableRushGlamCam extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bEnable;
var() bool bStopMatinee;

defaultproperties
{
    bEnable=true
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Enable",PropertyName=bEnable)
    ObjName="Enable Unit Rush Glam Cam"
}