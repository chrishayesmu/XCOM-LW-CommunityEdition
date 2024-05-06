class SeqAct_RestrictMovementCursorToCover extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor PathingUnit;
var() bool bFirstMoveOutOfCover;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="PathingUnit",PropertyName=PathingUnit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="bFirstMoveOutOfCover",PropertyName=bFirstMoveOutOfCover)
    ObjName="Restrict Movement Cursor To Cover"
}