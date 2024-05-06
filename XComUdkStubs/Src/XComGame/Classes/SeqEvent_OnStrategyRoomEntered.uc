class SeqEvent_OnStrategyRoomEntered extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var name RoomName;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks(0)=(LinkDesc="Base")
    OutputLinks(1)=(LinkDesc="MissionControl")
    VariableLinks.Empty()
    ObjName="OnRoomEntered"
}