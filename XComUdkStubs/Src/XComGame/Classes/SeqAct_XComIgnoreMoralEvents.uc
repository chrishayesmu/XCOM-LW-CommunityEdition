class SeqAct_XComIgnoreMoralEvents extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var array<XGUnit> Units;
var() bool bIgnoreMoralEvents;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Units",PropertyName=Units)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Ignore",PropertyName=bIgnoreMoralEvents)
    ObjName="XCom Ignore Moral Events"
}