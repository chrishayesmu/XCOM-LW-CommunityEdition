class XComWaitCondition_UnitSelected extends SeqAct_XComWaitCondition
    editinlinenew
    hidecategories(Object);

var() Actor UnitActor;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=UnitActor)
    ObjName="Wait for Unit Selection"
}