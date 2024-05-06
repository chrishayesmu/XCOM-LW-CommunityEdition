class SeqAct_PlayRoomSequence extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() string RoomName;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target",PropertyName=Targets)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="RoomName",PropertyName=RoomName)
    ObjName="Play Room Sequence"
}