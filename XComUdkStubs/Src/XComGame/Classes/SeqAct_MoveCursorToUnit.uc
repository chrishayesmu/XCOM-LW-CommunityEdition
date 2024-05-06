class SeqAct_MoveCursorToUnit extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target XGUnit or UnitPawn",PropertyName=TargetActor)
    ObjName="Move Cursor To Unit"
}