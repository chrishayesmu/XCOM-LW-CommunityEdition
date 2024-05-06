class SeqEvent_OnMoveUnit extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object BeginUnit;
var Object EndUnit;
var string MoveState;
var float MoveDistance;
var() bool bIsForAI;
var() float MinimumDistance;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    bClientAndServer=true
    OutputLinks(0)=(LinkDesc="Begin")
    OutputLinks(1)=(LinkDesc="End")
    OutputLinks(2)=(LinkDesc="Abort")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Beginning Unit",PropertyName=BeginUnit,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Ending Unit",PropertyName=EndUnit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkDesc="BreadCrumbs",PropertyName=Breadcrumbs,bWriteable=true)
    ObjName="OnMoveUnit"
}