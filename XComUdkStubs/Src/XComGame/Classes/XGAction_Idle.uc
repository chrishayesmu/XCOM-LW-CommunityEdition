class XGAction_Idle extends XGAction_Base
    native(Action)
    notplaceable
    hidecategories(Navigation);

var XComIdleAnimationStateMachine IdleStateMachine;

defaultproperties
{
    m_bModal=false
    m_bExecutionStopsTurnTimer=false
}