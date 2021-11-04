// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class SeqAct_GetActiveUnit extends SequenceAction;

var XGUnit Unit;
var XComUnitPawn UnitPawn;

event Activated()
{
}
function XGPlayer GetHumanPlayer()
{
}
defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=Unit,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="Get Active Unit"
}
