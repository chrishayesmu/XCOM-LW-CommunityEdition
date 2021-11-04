// extend UIEvent if this event should be UI Kismet Event instead of a Level Kismet Event
class SeqEvent_OnUnitTouchedDropshipVolume extends SequenceEvent
	forcescriptorder(true)
	hidecategories(Object);

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    ObjName="On Unit Touched Dropship Volume"
}
