class XGAction_Wait extends XGAction
    notplaceable
    hidecategories(Navigation);

enum eWaitStatus
{
    eWS_Begin,
    eWS_Overmind,
    eWS_PodMgr,
    eWS_Complete,
    eWS_MAX
};

var bool bAbort;
var eWaitStatus m_eWaitState;

defaultproperties
{
    m_bBlocksInput=true
    m_bConstantCombat=true
}