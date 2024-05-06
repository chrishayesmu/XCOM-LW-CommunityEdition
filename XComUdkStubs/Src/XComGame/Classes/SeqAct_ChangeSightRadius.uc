class SeqAct_ChangeSightRadius extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() int SightRadius;

defaultproperties
{
    SightRadius=22
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Targets",PropertyName=Targets)
    ObjName="Change Sight Radius"
}