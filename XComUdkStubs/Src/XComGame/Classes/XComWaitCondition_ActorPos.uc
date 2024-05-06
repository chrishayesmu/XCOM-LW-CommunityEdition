class XComWaitCondition_ActorPos extends XComWaitCondition_DistanceCheck
    editinlinenew
    hidecategories(Object);

var() Actor Actor;
var() name ActorName;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Actor",PropertyName=Actor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Locator",PropertyName=Locator)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Radius",PropertyName=Radius)
    ObjName="Wait for Actor Position"
}