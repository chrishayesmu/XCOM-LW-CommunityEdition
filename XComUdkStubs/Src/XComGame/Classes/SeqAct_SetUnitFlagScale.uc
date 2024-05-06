class SeqAct_SetUnitFlagScale extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor TargetActor;
var() int UIScale;
var() int PreviewMoves;

defaultproperties
{
    PreviewMoves=-1
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=TargetActor)
    ObjName="Set Unit UI Flag Scale"
}