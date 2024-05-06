class SeqEvent_OnChangeWeapon extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object FiringUnit;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Firing Unit",PropertyName=FiringUnit,bWriteable=true)
    ObjName="OnChangeWeapon"
}