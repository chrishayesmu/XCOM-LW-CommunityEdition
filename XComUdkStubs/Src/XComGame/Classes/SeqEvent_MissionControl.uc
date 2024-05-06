class SeqEvent_MissionControl extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks(0)=(LinkDesc="FundingCouncilOn")
    OutputLinks(1)=(LinkDesc="FundingCouncilOff")
    OutputLinks(2)=(LinkDesc="HoloGlobeOn")
    OutputLinks(3)=(LinkDesc="HoloGlobeOff")
    OutputLinks(4)=(LinkDesc="GlobeOn")
    OutputLinks(5)=(LinkDesc="GlobeOff")
    VariableLinks.Empty()
    ObjName="MissionControl"
}