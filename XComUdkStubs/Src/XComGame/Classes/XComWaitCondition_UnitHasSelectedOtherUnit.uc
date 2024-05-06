class XComWaitCondition_UnitHasSelectedOtherUnit extends SeqAct_XComWaitCondition
    editinlinenew
    hidecategories(Object);

var() Actor UnitActor;
var() Actor OtherUnitActor;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=UnitActor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Other Unit",PropertyName=OtherUnitActor)
    ObjName="Wait for Unit Having Selected Other Unit"
}