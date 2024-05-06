class SeqEvent_OnUnitChangedIndoors extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var int Floor;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks(0)=(LinkDesc="Outdoors")
    OutputLinks(1)=(LinkDesc="Indoors")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Instigator",bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Floor",PropertyName=Floor)
    ObjName="UnitChangedIndoorState"
}