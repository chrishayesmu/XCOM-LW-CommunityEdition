class SeqAct_SwapTeams extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var() ETeam DestinationTeam;

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="TargetActor",PropertyName=TargetActor)
    ObjName="Swap Teams"
}