class SeqAct_UnitSpeak extends SequenceAction
    dependson(XGGameData)
    forcescriptorder(true)
    hidecategories(Object);

var Object Unit;
var() ECharacterSpeech Event;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=Unit)
    ObjName="Unit Speak"
}