class SeqEvent_OnRevealPod extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object FocusUnit;
var Object SecondUnit;
var Object ThirdUnit;
var Vector vPodLoc;
var Vector vPodRot;
var int iPodType;
var int triggeredPodID;
var() int thisPodID;
var() bool staticMapPodsOnly;
var bool bAlerted;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Pod Type",PropertyName=iPodType,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Focus Unit (required)",PropertyName=FocusUnit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Second Unit (optional)",PropertyName=SecondUnit,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Third Unit (optional)",PropertyName=ThirdUnit,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="Pod Location",PropertyName=vPodLoc,bWriteable=true)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="Pod Rotation",PropertyName=vPodRot,bWriteable=true)
    ObjName="OnRevealPod"
}