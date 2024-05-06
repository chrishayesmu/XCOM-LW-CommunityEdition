class SeqAct_DisplayUIWorldMessageBoxTimed extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var string Message;
var XGUnit kUnit;
var Vector vLocation;
var() string MessageBoxIdentifier;
var() float DisplayTime;
var() bool Steady;

defaultproperties
{
    DisplayTime=5.0
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Display Message",PropertyName=Message)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Unit...",PropertyName=kUnit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Vector',LinkDesc="... or VLocation",PropertyName=vLocation,bWriteable=true)
    ObjName="UI Floating World Message Box"
}