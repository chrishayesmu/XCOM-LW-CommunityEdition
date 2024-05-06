class SeqEvent_OnActivatePod extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object Alien1;
var Object Alien2;
var Object Alien3;
var Vector vPodLoc;
var Vector vPodRot;
var int iPodType;
var int triggeredPodID;
var() int thisPodID;
var bool bAlerted;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks(0)=(LinkDesc="Alerted")
    OutputLinks(1)=(LinkDesc="Unalerted")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Pod Type",PropertyName=iPodType,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="Pod Location",PropertyName=vPodLoc,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="Pod Rotation",PropertyName=vPodRot,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Alien1",PropertyName=Alien1,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Alien2",PropertyName=Alien2,bWriteable=true)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Alien3",PropertyName=Alien3,bWriteable=true)
    ObjName="OnActivatePod"
}