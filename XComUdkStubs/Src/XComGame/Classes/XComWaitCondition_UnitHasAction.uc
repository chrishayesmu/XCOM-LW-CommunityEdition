class XComWaitCondition_UnitHasAction extends SeqAct_XComWaitCondition
    editinlinenew
    hidecategories(Object);

var() Actor UnitActor;
var() class<XGAction> ActionToWait;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=UnitActor)
    ObjName="Wait for Unit Having Action"
}