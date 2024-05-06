class SeqAct_ShowWaypoint extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() XComWaypointActor WaypointActor;
var() bool bShow;

defaultproperties
{
    bShow=true
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Waypoint",PropertyName=WaypointActor)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="Show",PropertyName=bShow)
    ObjName="UI Show Waypoint"
}