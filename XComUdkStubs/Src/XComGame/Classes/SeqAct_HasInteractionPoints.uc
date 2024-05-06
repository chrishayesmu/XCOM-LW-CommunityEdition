class SeqAct_HasInteractionPoints extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;

defaultproperties
{
    OutputLinks(0)=(LinkDesc="True")
    OutputLinks(1)=(LinkDesc="False")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    ObjName="Has Interaction Points"
}