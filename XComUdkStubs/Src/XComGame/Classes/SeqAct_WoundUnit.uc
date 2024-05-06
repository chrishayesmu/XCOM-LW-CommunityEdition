class SeqAct_WoundUnit extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var int Damage;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="Damage",PropertyName=Damage)
    ObjName="Wound Unit"
}