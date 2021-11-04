class XGAction_Idle extends XGAction_Base
    native(Action);
//complete stub

var XComIdleAnimationStateMachine IdleStateMachine;

function bool Init(XGUnit kUnit){}
simulated event SimulatedInit(){}
function bool HasRedRingForAI(){}
simulated function bool InternalIsInterruptibleBy(class<XGAction> kActionClass){}
simulated function InternalCompleteAction(){}
simulated event Destroyed();

simulated state Executing{}
