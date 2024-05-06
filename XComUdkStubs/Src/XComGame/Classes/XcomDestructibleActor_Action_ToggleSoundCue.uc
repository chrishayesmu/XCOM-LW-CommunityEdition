class XcomDestructibleActor_Action_ToggleSoundCue extends XComDestructibleActor_Action within XComDestructibleActor
    native(Destruction)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var(XComDestructibleActor_Action) AmbientSound Sound;
var() bool bStopOnly;

defaultproperties
{
    bStopOnly=true
}