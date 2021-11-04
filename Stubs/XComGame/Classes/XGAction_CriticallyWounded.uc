class XGAction_CriticallyWounded extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

var float fTimeOut;
var bool m_bOnLoadGame;
var transient AnimNodeSequence tmpAnimSequence;

simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit, optional bool bOnLoadGame){}

simulated event SimulatedInit(){}
function bool CanBePerformed(){}
simulated state Executing
{
}
simulated state CriticallyWounding
{
}
simulated state CriticallyWounded
{
}