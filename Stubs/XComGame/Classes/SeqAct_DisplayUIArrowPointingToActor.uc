class SeqAct_DisplayUIArrowPointingToActor extends SequenceAction
    hidecategories(Object)
    forcescriptorder(true);

var Object kTarget;
var Vector Offset;
var int iCount;
var bool bShow;

event Activated()
{
}

defaultproperties
{
    iCount=-1
    bCallHandler=false
    InputLinks(0)=(LinkDesc="yellow")
    InputLinks(1)=(LinkDesc="meld")
    InputLinks(2)=(LinkDesc="red")
    InputLinks(3)=(LinkDesc="blue")
    InputLinks(4)=(LinkDesc="gray")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=kTarget,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="Vector Offset",PropertyName=Offset,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="bShow?",PropertyName=bShow,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Counter",PropertyName=iCount,bWriteable=true)
    ObjName="UI Arrow Pointing at Actor"
}