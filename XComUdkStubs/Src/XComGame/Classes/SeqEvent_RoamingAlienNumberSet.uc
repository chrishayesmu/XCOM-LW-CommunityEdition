class SeqEvent_RoamingAlienNumberSet extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var int iNumAliens;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Alien Number",PropertyName=iNumAliens,bWriteable=true)
    ObjName="RoamingAlienNumberSet"
}