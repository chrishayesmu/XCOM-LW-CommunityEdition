class XComWaitCondition_UnitAction extends SeqAct_XComWaitCondition
    editinlinenew
    hidecategories(Object);

var() Actor UnitActor;
var int LastActionID;
var bool bLastActionGrabbed;

defaultproperties
{
    LastActionID=-1
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=UnitActor)
    ObjName="Wait for Unit Action"
}