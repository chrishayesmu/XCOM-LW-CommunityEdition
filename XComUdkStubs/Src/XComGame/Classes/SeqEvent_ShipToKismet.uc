class SeqEvent_ShipToKismet extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object Ship1;
var Object Ship2;
var Object Ship3;
var Object Ship4;
var Object Firestorm1;
var Object Firestorm2;
var Object Firestorm3;
var Object Firestorm4;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Ship 1",PropertyName=Ship1,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Ship 2",PropertyName=Ship2,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Ship 3",PropertyName=Ship3,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Ship 4",PropertyName=Ship4,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Firestorm 1",PropertyName=Firestorm1,bWriteable=true)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Firestorm 2",PropertyName=Firestorm2,bWriteable=true)
    VariableLinks(6)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Firestorm 3",PropertyName=Firestorm3,bWriteable=true)
    VariableLinks(7)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Firestorm 4",PropertyName=Firestorm4,bWriteable=true)
    ObjName="ShipToKismet"
}