class SeqAct_GetMatineePawns extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XComPawn Soldier1;
var XComPawn Soldier2;
var XComPawn Soldier3;
var XComPawn Soldier4;
var XComPawn Soldier5;
var XComPawn Soldier6;
var XComPawn Mec1;
var XComPawn Mec2;
var XComPawn Mec3;
var XComPawn Mec4;
var XComPawn Mec5;
var XComPawn Mec6;
var XComPawn Shiv1;
var XComPawn Shiv2;
var XComPawn Shiv3;
var XComPawn Shiv4;
var XComPawn Shiv5;
var XComPawn Shiv6;
var int NumAvailable;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier1",PropertyName=Soldier1,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier2",PropertyName=Soldier2,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier3",PropertyName=Soldier3,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier4",PropertyName=Soldier4,bWriteable=true)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier5",PropertyName=Soldier5,bWriteable=true)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Soldier6",PropertyName=Soldier6,bWriteable=true)
    VariableLinks(6)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec1",PropertyName=Mec1,bWriteable=true)
    VariableLinks(7)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec2",PropertyName=Mec2,bWriteable=true)
    VariableLinks(8)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec3",PropertyName=Mec3,bWriteable=true)
    VariableLinks(9)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec4",PropertyName=Mec4,bWriteable=true)
    VariableLinks(10)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec5",PropertyName=Mec5,bWriteable=true)
    VariableLinks(11)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Mec6",PropertyName=Mec6,bWriteable=true)
    VariableLinks(12)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv1",PropertyName=Shiv1,bWriteable=true)
    VariableLinks(13)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv2",PropertyName=Shiv2,bWriteable=true)
    VariableLinks(14)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv3",PropertyName=Shiv3,bWriteable=true)
    VariableLinks(15)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv4",PropertyName=Shiv4,bWriteable=true)
    VariableLinks(16)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv5",PropertyName=Shiv5,bWriteable=true)
    VariableLinks(17)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shiv6",PropertyName=Shiv6,bWriteable=true)
    VariableLinks(18)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="NumAvailable",PropertyName=NumAvailable,bWriteable=true)
    ObjName="Get Matinee Units"
}