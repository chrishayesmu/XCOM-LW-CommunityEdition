class SeqAct_GetSquadMemberCount extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var int TotalSquadMemberCount;
var int AliveSquadMemberCount;
var int DeadSquadMemberCount;

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Human")
    InputLinks(1)=(LinkDesc="Alien")
    InputLinks(2)=(LinkDesc="Civilian")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Total",PropertyName=TotalSquadMemberCount,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Alive",PropertyName=AliveSquadMemberCount,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Dead/Crit. Wound",PropertyName=DeadSquadMemberCount,bWriteable=true)
    ObjName="Get Squad Member Count"
}