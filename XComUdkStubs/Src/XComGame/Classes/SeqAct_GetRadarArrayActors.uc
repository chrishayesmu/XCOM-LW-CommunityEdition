class SeqAct_GetRadarArrayActors extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor RadarActor1;
var Actor RadarActor2;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Radar Actor 1",PropertyName=RadarActor1,bWriteable=true)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Radar Actor 2",PropertyName=RadarActor2,bWriteable=true)
    ObjName="Get Radar Array Actors"
}