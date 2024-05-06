class SeqAct_ActivateInputGateSystem extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var bool bEnable;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="bEnable",PropertyName=bEnable,bWriteable=true)
    ObjName="Activate Input Gate System"
}