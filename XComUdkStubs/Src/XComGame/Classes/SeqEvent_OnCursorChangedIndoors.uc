class SeqEvent_OnCursorChangedIndoors extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks(0)=(LinkDesc="Outdoors")
    OutputLinks(1)=(LinkDesc="Indoors")
    ObjName="CursorChangedIndoorState"
}