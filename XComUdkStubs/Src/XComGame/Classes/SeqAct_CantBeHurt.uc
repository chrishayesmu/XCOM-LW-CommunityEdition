class SeqAct_CantBeHurt extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=TargetActor)
    ObjName="Cant Be Hurt"
}