class SeqAct_SetRadius extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var float Radius;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target",PropertyName=Targets)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Radius",PropertyName=Radius)
    ObjName="Set Piece Radius"
}