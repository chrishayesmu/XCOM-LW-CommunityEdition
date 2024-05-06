class SeqAct_GetLocation extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Vector Location;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target",PropertyName=Targets)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="Location",PropertyName=Location,bWriteable=true)
    ObjName="Get Unit Location"
}