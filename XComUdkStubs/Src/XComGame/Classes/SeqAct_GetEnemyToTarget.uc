class SeqAct_GetEnemyToTarget extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Object FiringActor;
var XGUnit Unit;
var XComUnitPawn UnitPawn;
var int CoverSearchOrder[9];

defaultproperties
{
    CoverSearchOrder[1]=1
    CoverSearchOrder[2]=2
    CoverSearchOrder[3]=7
    CoverSearchOrder[4]=8
    CoverSearchOrder[5]=3
    CoverSearchOrder[6]=4
    CoverSearchOrder[7]=5
    CoverSearchOrder[8]=6
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Best")
    InputLinks(1)=(LinkDesc="Worst")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Firing Unit",PropertyName=FiringActor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Unit",PropertyName=Unit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Unit Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="Get Enemy To Target"
}