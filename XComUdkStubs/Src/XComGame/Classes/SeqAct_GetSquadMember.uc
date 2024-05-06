class SeqAct_GetSquadMember extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() int SquadMemberIndex;
var XGUnit Unit;
var XComUnitPawn UnitPawn;
var() bool CollapseSlots;

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Any")
    InputLinks(1)=(LinkDesc="Mecs")
    InputLinks(2)=(LinkDesc="Soldiers")
    InputLinks(3)=(LinkDesc="Shivs")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Squad Member Index",PropertyName=SquadMemberIndex)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=Unit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="Get Squad Member"
}