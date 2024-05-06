class SeqEvent_OnTacticalIntro extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var string strMapName;
var Object Soldier1;
var Object Soldier2;
var Object Soldier3;
var Object Soldier4;
var Object Soldier5;
var Object Soldier6;
var Object Mec1;
var Object Mec2;
var Object Mec3;
var Object Mec4;
var Object Mec5;
var Object Mec6;
var Object Shiv1;
var Object Shiv2;
var Object Shiv3;
var Object Shiv4;
var Object Shiv5;
var Object Shiv6;
var Object BattleObj;
var int iSpawnGroup;
var() bool CollapseSlots;

defaultproperties
{
    bPlayerOnly=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Map Name",PropertyName=strMapName,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier 1",PropertyName=Soldier1,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier 2",PropertyName=Soldier2,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier 3",PropertyName=Soldier3,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier 4",PropertyName=Soldier4,bWriteable=true)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier 5",PropertyName=Soldier5,bWriteable=true)
    VariableLinks(6)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier 6",PropertyName=Soldier6,bWriteable=true)
    VariableLinks(7)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Battle Obj",PropertyName=BattleObj,bWriteable=true)
    VariableLinks(8)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Spawn Group",PropertyName=iSpawnGroup,bWriteable=true)
    VariableLinks(9)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec 1",PropertyName=Mec1,bWriteable=true)
    VariableLinks(10)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec 2",PropertyName=Mec2,bWriteable=true)
    VariableLinks(11)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec 3",PropertyName=Mec3,bWriteable=true)
    VariableLinks(12)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec 4",PropertyName=Mec4,bWriteable=true)
    VariableLinks(13)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec 5",PropertyName=Mec5,bWriteable=true)
    VariableLinks(14)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec 6",PropertyName=Mec6,bWriteable=true)
    VariableLinks(15)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv 1",PropertyName=Shiv1,bWriteable=true)
    VariableLinks(16)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv 2",PropertyName=Shiv2,bWriteable=true)
    VariableLinks(17)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv 3",PropertyName=Shiv3,bWriteable=true)
    VariableLinks(18)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv 4",PropertyName=Shiv4,bWriteable=true)
    VariableLinks(19)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv 5",PropertyName=Shiv5,bWriteable=true)
    VariableLinks(20)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv 6",PropertyName=Shiv6,bWriteable=true)
    ObjName="OnTacticalIntro"
}