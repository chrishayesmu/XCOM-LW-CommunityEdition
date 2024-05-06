class SeqAct_UnrestrictMovementCursor extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor PathingUnit;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="PathingUnit",PropertyName=PathingUnit)
    ObjName="Unrestrict Movement Cursor"
}