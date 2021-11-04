class XGAction_FireOverwatchExecuting extends XGAction_FireImmediate
	notplaceable
	hidecategories(Navigation);
//complete stub

var XGUnit m_kFirstOverwatcher;
var XGUnit m_kPreviousOverwatcher;
var Vector vAutoZoomLookAtCenter;
var XGAction_Fire m_kTargetFireAction;
var bool m_bCloseCombatShot;
var const localized string m_strReactionFire;
var const localized string m_strAlienReactionFire;

replication
{
	if(bNetInitial && Role == ROLE_Authority)
		m_bCloseCombatShot;
}

function bool Init_FireOverwatchExecuting(XGUnit kUnit, bool bCloseCombatShot){}
simulated function bool InternalIsInterruptibleBy(class<XGAction> kActionClass){}
simulated function InternalCompleteAction(){}


simulated state Executing
{
	simulated function bool WaitingToFire(){}
}

simulated state ShutDownToIdle
{
	simulated event BeginState(name P){}
	simulated event EndState(name P){}

}