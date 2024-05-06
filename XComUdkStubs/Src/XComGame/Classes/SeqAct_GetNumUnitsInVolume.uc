class SeqAct_GetNumUnitsInVolume extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Volume UnitVolume;
var int XComUnitCount;
var int AlienUnitCount;
var int CivilianUnitCount;
var int TotalUnitCount;

defaultproperties
{
    InputLinks(0)=(LinkDesc="All")
    InputLinks(1)=(LinkDesc="Alive and Well only")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Volume",PropertyName=UnitVolume)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="XCom",PropertyName=XComUnitCount,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Alien",PropertyName=AlienUnitCount,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Civilian",PropertyName=CivilianUnitCount,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Total",PropertyName=TotalUnitCount,bWriteable=true)
    ObjName="Get Num Units In Volume"
}