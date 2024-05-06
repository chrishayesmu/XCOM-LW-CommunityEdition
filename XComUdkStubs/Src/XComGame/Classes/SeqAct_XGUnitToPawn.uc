class SeqAct_XGUnitToPawn extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Object Unit;
var Pawn UnitPawn;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="XGUnit",PropertyName=Unit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="XGUnitToPawn"
}