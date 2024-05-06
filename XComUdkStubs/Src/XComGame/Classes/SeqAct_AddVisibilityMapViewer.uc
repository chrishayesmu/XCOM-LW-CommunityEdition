class SeqAct_AddVisibilityMapViewer extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor Viewer;
var() int SightRadius;

defaultproperties
{
    SightRadius=10
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Viewer Actor",PropertyName=Viewer)
    ObjName="Add VisibilityMapViewer"
}