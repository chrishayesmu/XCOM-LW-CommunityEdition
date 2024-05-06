class SeqCond_IsUnitTouchingVolume extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

var Object kUnit;
var Volume kVolume;

defaultproperties
{
    OutputLinks(0)=(LinkDesc="False")
    OutputLinks(1)=(LinkDesc="True")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=kUnit)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Volume",PropertyName=kVolume)
    ObjName="Is Unit In Volume"
}