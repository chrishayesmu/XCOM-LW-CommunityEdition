class SeqAct_ZoomCamera extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var float Zoom;

defaultproperties
{
    Zoom=1.0
    OutputLinks(0)=(LinkDesc="False")
    OutputLinks(1)=(LinkDesc="True")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Zoom",PropertyName=Zoom)
    ObjName="Zoom camera"
}