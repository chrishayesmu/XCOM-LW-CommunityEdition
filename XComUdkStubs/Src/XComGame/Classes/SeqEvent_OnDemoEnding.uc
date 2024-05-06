class SeqEvent_OnDemoEnding extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Object Soldier;
var Object Muton1;
var Object Muton2;
var Object ActionObj;

defaultproperties
{
    bPlayerOnly=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier",PropertyName=Soldier,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Muton 1",PropertyName=Muton1,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Muton 2",PropertyName=Muton2,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Action_Fire Obj",PropertyName=ActionObj,bWriteable=true)
    ObjName="OnDemoEnding"
}