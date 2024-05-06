class SeqCond_HasFiredRocketLauncher extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    OutputLinks(0)=(LinkDesc="True")
    OutputLinks(1)=(LinkDesc="False")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit")
    ObjName="Has Fired Rocket Launcher"
}