class SeqAct_DTEFromSave extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

struct TTurns
{
    var() name RemoteEvent;
    var() array<XComWaypointActor> Waypoints;
};

var() array<TTurns> Turns;

defaultproperties
{
    bCallHandler=false
    ObjName="DTE From Save"
}