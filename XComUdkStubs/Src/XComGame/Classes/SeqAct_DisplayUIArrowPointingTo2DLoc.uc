class SeqAct_DisplayUIArrowPointingTo2DLoc extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Vector Loc;
var string Id;
var float rotationDegrees;
var bool bShow;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Unique String ID",PropertyName=Id,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="2D Vector Location",PropertyName=Loc,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Rotation (degrees)",PropertyName=rotationDegrees,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="bShow?",PropertyName=bShow,bWriteable=true)
    ObjName="UI Arrow Pointing at 2D Location"
}