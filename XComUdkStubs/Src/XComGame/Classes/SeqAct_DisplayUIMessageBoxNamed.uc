class SeqAct_DisplayUIMessageBoxNamed extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var string Id;
var string Message;
var bool bCreate;
var bool bDestroy;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="ID",PropertyName=Id)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Display Message",PropertyName=Message)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Create?",PropertyName=bCreate,bWriteable=true)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Destroy?",PropertyName=bDestroy,bWriteable=true)
    ObjName="UI Message Box Persistant"
}