class SeqAct_GetCovertOperative extends SequenceAction;

var XGUnit Unit;
var XComUnitPawn UnitPawn;

event Activated()
{
}

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=Unit,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="Get Covert Operative"
}
