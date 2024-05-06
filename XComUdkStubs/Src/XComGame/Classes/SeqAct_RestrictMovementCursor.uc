class SeqAct_RestrictMovementCursor extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor PathingUnit;
var() Actor Locator;
var() bool SnapToLocator;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="PathingUnit",PropertyName=PathingUnit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Locator",PropertyName=Locator)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="SnapToLocator",PropertyName=SnapToLocator)
    ObjName="Restrict Movement Cursor"
}