class SeqEvent_HQUnits extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object Unit0;
var Object Unit1;
var Object Unit2;
var Object Unit3;
var Object Unit4;
var Object Unit5;
var Object Unit6;
var Object Unit7;
var Object Unit8;
var Object Unit9;
var Object Unit10;
var Object Unit11;
var() const int MaxUnits;
var() Actor CineDummy;
var() bool bDisableGenderBlender;

defaultproperties
{
    MaxUnits=12
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks(0)=(LinkDesc="Play")
    OutputLinks(1)=(LinkDesc="Stop")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 0",PropertyName=Unit0,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 1",PropertyName=Unit1,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 2",PropertyName=Unit2,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 3",PropertyName=Unit3,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 4",PropertyName=Unit4,bWriteable=true)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 5",PropertyName=Unit5,bWriteable=true)
    VariableLinks(6)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 6",PropertyName=Unit6,bWriteable=true)
    VariableLinks(7)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 7",PropertyName=Unit7,bWriteable=true)
    VariableLinks(8)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 8",PropertyName=Unit8,bWriteable=true)
    VariableLinks(9)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 9",PropertyName=Unit9,bWriteable=true)
    VariableLinks(10)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 10",PropertyName=Unit10,bWriteable=true)
    VariableLinks(11)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit 11",PropertyName=Unit11,bWriteable=true)
    ObjName="HQ Units"
}