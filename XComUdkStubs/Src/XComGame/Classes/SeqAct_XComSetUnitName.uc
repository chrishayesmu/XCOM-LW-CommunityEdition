class SeqAct_XComSetUnitName extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var string InputFirstName;
var string InputLastName;
var string InputNickName;

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="TargetActor",PropertyName=TargetActor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="First Name",PropertyName=InputFirstName)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Last Name",PropertyName=InputLastName)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Nick Name",PropertyName=InputNickName)
    ObjName="Set Unit Name"
}