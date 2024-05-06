class SeqAct_GetActiveUnit extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XGUnit Unit;
var XComUnitPawn UnitPawn;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=Unit,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="Get Active Unit"
}