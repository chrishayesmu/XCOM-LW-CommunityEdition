class SeqEvent_OnFireUponUnit extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object FiringUnit;
var Object TargetUnit;
var Object WeaponObject;
var bool bKillshot;
var bool bFirUnitLow;
var bool bTarUnitLow;
var bool bIsMiss;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks(0)=(LinkDesc="Human")
    OutputLinks(1)=(LinkDesc="AI")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Firing Unit",PropertyName=FiringUnit,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Unit",PropertyName=TargetUnit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Weapon Object",PropertyName=WeaponObject,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Is Kill Shot",PropertyName=bKillshot,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Is FirUnit Low",PropertyName=bFirUnitLow,bWriteable=true)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Is TarUnit Low",PropertyName=bTarUnitLow,bWriteable=true)
    VariableLinks(6)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Is Miss",PropertyName=bIsMiss,bWriteable=true)
    ObjName="OnFireUponUnit"
}