class SeqEvent_DestructibleStatusChanged extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks(0)=(LinkDesc="Damaged")
    OutputLinks(1)=(LinkDesc="Destroyed")
    OutputLinks(2)=(LinkDesc="Obliterated")
    VariableLinks.Empty()
    ObjName="XComDestructibleActor Status Change"
}