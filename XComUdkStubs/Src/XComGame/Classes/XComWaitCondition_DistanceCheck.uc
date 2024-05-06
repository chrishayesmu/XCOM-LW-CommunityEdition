class XComWaitCondition_DistanceCheck extends SeqAct_XComWaitCondition
    abstract
    editinlinenew
    hidecategories(Object);

var() Actor Locator;
var() float Radius;

defaultproperties
{
    Radius=96.0
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Locator",PropertyName=Locator)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Radius",PropertyName=Radius)
}