class SeqAct_SetCyberdiscState extends SequenceAction
    dependson(XGTacticalGameCoreData)
    forcescriptorder(true)
    hidecategories(Object);

var XComUnitPawn kPawn;
var() EUnitPawn_OpenCloseState eState;
var() bool bImmediate;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawn",PropertyName=kPawn)
    ObjName="Set Cyberdisc State"
}