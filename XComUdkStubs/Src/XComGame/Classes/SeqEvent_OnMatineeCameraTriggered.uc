class SeqEvent_OnMatineeCameraTriggered extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object Camera;
var Vector Location;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Instigator",bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Camera",PropertyName=Camera,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="Location",PropertyName=Location,bWriteable=true)
    ObjName="OnMatineeCameraTriggered"
}